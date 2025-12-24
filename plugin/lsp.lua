if vim.g.vscode then
	return {}
end

vim.lsp.inlay_hint.enable(true, nil)
vim.diagnostic.config({ virtual_text = true })

vim.lsp.enable({
	"astro",
	"ty",
	"bashls",
	"biome",
	"clangd",
	"cssls",
	"docker_language_server",
	"eslint",
	"fish_lsp",
	"gleam",
	"html",
	"jsonls",
	"julials",
	"lua_ls",
	"marksman",
	"nixd",
	"ocamllsp",
	"svelte",
	"tailwind",
	"taplo",
	"texlab",
	"tinymist",
	"vtsls",
	"yamlls",
	"ruff",

	-- activated through seperate plugin:
	-- "rust_analyzer"
	-- "jdtls",
})

-- ocaml config in ../../lsp/ocamllsp.lua

vim.lsp.config("vtsls", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@astrojs/ts-plugin",
						-- TODO:
						location = vim.fn.stdpath("data")
							.. "/mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin",
						enableForWorkspaceTypeScriptVersions = true,
					},
					{
						name = "typescript-svelte-plugin",
						-- TODO:
						location = vim.fn.stdpath("data")
							.. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
	},
})

vim.lsp.config("clangd", {
	keys = {
		{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "switch source/header (c/cpp)" },
	},
})

vim.lsp.config("tailwind", {
	filetypes = { "astro" },
})

-- fidget.nvim
require("fidget").setup({ notification = { window = { winblend = 0 } } })

-- TODO: blink.cmp capabilities?
