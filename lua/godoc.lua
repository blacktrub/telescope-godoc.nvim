local packages = require("packages")

local function show_doc_page(ctx)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.fn.jobstart({ "go", "doc", ctx.args }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if data then
			  print(data, buf)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
			end
		end,
	})

	vim.api.buf(buf, true, {})
end

vim.api.nvim_create_user_command("GoDoc", show_doc_page, { nargs = 1 })
