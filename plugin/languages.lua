-- SchemaStore
vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

-- vim-dadbod
vim.g.db_ui_use_nerd_fonts = 1
