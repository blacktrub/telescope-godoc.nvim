local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local previewer_utils = require("telescope.previewers.utils")
-- TODO: do smth if doesn't have
local has_plenary, Job = pcall(require, "plenary.job")

local show_preview = function(entry, buf, callback)
	Job:new({
		command = "go",
		args = { "doc", entry.value },
		on_exit = function(job, exit_code)
			vim.schedule(function()
				if exit_code ~= 0 then
					vim.notify("failed to preview go document", vim.log.levels.ERROR)
					return
				end
				local result = job:result()
				if result then
					vim.api.nvim_buf_set_lines(buf, 0, -1, true, result)
					previewer_utils.highlighter(buf, "go")
					vim.api.nvim_buf_call(buf, function()
						local win = vim.fn.win_findbuf(buf)[1]
						vim.wo[win].conceallevel = 2
						vim.wo[win].wrap = true
						vim.wo[win].linebreak = true
						vim.bo[buf].textwidth = 80
					end)
				end

				if callback then
					callback()
				end
			end)
		end,
	}):start()
end

local picker_factory = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Golang Documentation",
			finder = finders.new_table({
				results = require("godoc.packages"),
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry,
						ordinal = entry,
						preview_command = show_preview,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewers.display_content.new(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					local buf = vim.api.nvim_create_buf(false, true)
					show_preview(entry, buf, function()
						vim.api.nvim_buf_set_option(buf, "modifiable", false)
						vim.api.nvim_buf_set_option(buf, "filetype", "go")

						local ui = vim.api.nvim_list_uis()[1]
						local width = math.floor(ui.width / 2)
						local height = 50
						-- TODO: how to calculate it properly
						if height > ui.height then
							height = ui.height - 5
						end
						vim.api.nvim_open_win(buf, true, {
							relative = "editor",
							style = "minimal",
							width = width,
							height = height,
							col = (ui.width / 2) - (width / 2),
							row = (ui.height / 2) - (height / 2),
							border = "rounded",
						})
					end)
				end)
				return true
			end,
		})
		:find()
end

return {
	picker = picker_factory,
}
