if vim.g.vscode then
	return {}
end

-- typst-preview.nvim
require("typst-preview").setup({})

-- SchemaStore
vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

-- {
-- 	"mrcjkb/rustaceanvim",
-- 	version = "^6", -- Recommended
-- 	lazy = false, -- This plugin is already lazy
-- },
--

-- render-markdown
require("render-markdown").setup({
	preset = "obsidian",
	completions = { blink = { enabled = true } },
	code = {
		sign = false,
	},
	heading = {
		position = "inline",
	},
	html = {
		comment = {
			conceal = false,
		},
	},
	latex = {
		enabled = false,
	},
	file_types = { "markdown" },
})

-- clangd_extensions
require("clangd_extensions").setup({
	ast = {
		role_icons = {
			type = "",
			declaration = "",
			expression = "",
			specifier = "",
			statement = "",
			["template argument"] = "",
		},

		kind_icons = {
			Compound = "",
			Recovery = "",
			TranslationUnit = "",
			PackExpansion = "",
			TemplateTypeParm = "",
			TemplateTemplateParm = "",
			TemplateParamObject = "",
		},
	},
	memory_usage = {
		border = "rounded",
	},
	symbol_info = {
		border = "rounded",
	},
})

-- vimtex
vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
vim.g.vimtex_view_method = "zathura"

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "tex", "plaintex" },
	callback = function()
		vim.keymap.set("n", "<LocalLeader>l", "<Nop>", { buffer = true, desc = "+vimtex" })
	end,
})

-- vim-dadbod
vim.g.db_ui_use_nerd_fonts = 1
