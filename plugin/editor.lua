if vim.g.vscode then
	return {}
end

-- nvim-treesitter
local ts = require("nvim-treesitter")
ts.setup({})

ts.install({ "stable", "unstable" }, { summary = true })

local installed = {}
for _, lang in ipairs(ts.get_installed("parsers")) do
	installed[lang] = true
end

local function have(ft)
	local lang = vim.treesitter.language.get_lang(ft)
	if lang == nil or installed[lang] == nil then
		return false
	end
	return true
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("nvim_treesitter", { clear = true }),
	callback = function(ev)
		if not have(ev.match) then
			return
		end

		vim.treesitter.start()
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "TSUpdate",
	callback = function()
		-- remove when support is upstreamed
		require("nvim-treesitter.parsers").crystal = {
			install_info = {
				url = "https://github.com/crystal-lang-tools/tree-sitter-crystal",
				generate = false,
				generate_from_json = false,
				queries = "queries/nvim",
			},
		}

		require("nvim-treesitter.parsers").ghostty = {
			install_info = {
				url = "https://github.com/bezhermoso/tree-sitter-ghostty",
				generate = false,
				generate_from_json = false,
				queries = "queries/ghostty",
			},
		}
	end,
})

vim.treesitter.language.register("crystal", { "cr" })

-- nvim-treesitter-context
require("treesitter-context").setup({ max_lines = 3 })

-- which-key.nvim
local wk = require("which-key")
wk.setup({
	preset = "helix",
})
wk.add({
	{ "<leader>a", group = "ai", icon = { icon = " ", color = "orange" } },
	{ "<leader>c", group = "code" },
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "git" },
	{ "<leader>p", group = "plugins", icon = { icon = " ", color = "cyan" } },
	{ "<leader>s", group = "search" },
	{ "<leader>u", group = "ui" },
	{ "<leader>x", group = "diagnostics", icon = { icon = "󱖫 ", color = "green" } },
	{ "g", group = "goto" },
	{ "[", group = "prev" },
	{ "]", group = "next" },
	{ "g", group = "goto" },
	{ "gs", group = "surround" },
	{ "z", group = "fold" },
})
vim.keymap.set({ "n", "v", "x" }, "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- trouble.nvim
require("trouble").setup({})
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ desc = "Trouble buffer diagnostics" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>", { desc = "Trouble symbols" })
vim.keymap.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "Trouble LSP" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble location list" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Trouble quickfix list" })

-- gitsigns.nvim
require("gitsigns").setup({})

-- flash.nvim
require("flash").setup({
	labels = "asdfghjklöäqwertyuiopüzxcvbnm",
	modes = {
		search = {
			enabled = true,
		},
	},
})
vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })

--- precognition.nvim
require("precognition").setup({ startVisible = false })
vim.keymap.set("n", "<leader>up", function()
	require("precognition").peek()
end, { desc = "show motions" })

-- rainbow-delimiters
require("rainbow-delimiters.setup").setup({}) --TODO: do i need to call setup?
