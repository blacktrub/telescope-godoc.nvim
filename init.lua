local function godoc(s)
	local data = vim.cmd("!go doc " .. s, false)
	print(data)
end

local function show_doc_page(ctx)
	godoc(ctx.args)
end

vim.api.nvim_create_user_command("GoDoc", show_doc_page, { nargs = 1 })
