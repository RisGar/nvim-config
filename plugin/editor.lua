if vim.g.vscode then
	return {}
end

-- nvim-treesitter
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("nvim_treesitter", { clear = true }),
	callback = function(ev)
		if vim.treesitter.get_parser(ev.buf, nil, { error = false }) == nil then
			return
		end

		vim.treesitter.start(ev.buf)
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

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

--- precognition.nvim
require("precognition").setup({ startVisible = false })
vim.keymap.set("n", "<leader>up", function()
	require("precognition").peek()
end, { desc = "show motions" })

-- rainbow-delimiters
require("rainbow-delimiters.setup").setup({}) --TODO: do i need to call setup?
