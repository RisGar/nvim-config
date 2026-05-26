vim.lsp.inlay_hint.enable(true, nil)
vim.diagnostic.config({ virtual_text = true })

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "line diagnostics" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "code action" })
		vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { buffer = ev.buf, desc = "run codelens" })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "rename" })
	end,
})

-- TODO: lsp foldexprs vs ts foldexprs

vim.lsp.enable({
	"astro",
	"ty",
	"bashls",
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
	"tailwindcss",
	"taplo",
	"texlab",
	"tinymist",
	"vtsls",
	"yamlls",
	"ruff",
	"rust_analyzer",
	"oxlint",
	"statix",

	-- activated through seperate plugin:
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
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@astrojs/ts-plugin",
						location = vim.g.astro_ts_plugin_path,
						enableForWorkspaceTypeScriptVersions = true,
					},
					{
						name = "typescript-plugin",
						location = vim.g.svelte_ts_plugin_path,
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
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

-- fidget.nvim
require("fidget").setup({ notification = { window = { winblend = 0 } } })

-- blink.cmp capabilities
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

-- Codelens
vim.lsp.codelens.enable(true)
