local packages = require("packages")

local function show_doc_page(ctx)
	vim.cmd("tabnew | r ! go doc " .. ctx.args)
end

vim.api.nvim_create_user_command("GoDoc", show_doc_page, { nargs = 1 })
