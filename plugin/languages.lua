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

vim.lsp.config("astro", {
	init_options = {
		typescript = {
			tsdk = vim.g.typescript_sdk_path,
		},
	},
})

vim.lsp.config("clangd", {
	keys = {
		{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "switch source/header (c/cpp)" },
	},
})

vim.g.rustaceanvim = {
	-- LSP configuration
	server = {
		default_settings = {
			-- rust-analyzer language server configuration
			["rust-analyzer"] = {
				files = {
					excludeDirs = {
						".direnv",
						".cargo",
						".git",
						".jj",
						"target",
					},
				},
			},
		},
	},
}

-- vim-dadbod
vim.g.db_ui_use_nerd_fonts = 1
