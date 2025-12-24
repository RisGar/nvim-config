----- Keymaps that don't belong to specific plugin -----

vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Up>", "<Nop>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "exit terminal mode" }) -- exit terminal mode

-- TODO: move
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "run codelens" })
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "line diagnostics" })
vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "refresh codelens" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "rename" })
vim.keymap.set("n", "<leader>cw", vim.lsp.buf.rename, { desc = "write" })

-- vim.keymap.set("n", "<leader>qq", "<cmd>qall<cr>", { desc = "quit all" })
vim.keymap.set({ "n", "v", "i" }, "<C-h>", "<cmd>bprevious<cr>", { desc = "previous buffer", remap = true })
vim.keymap.set({ "n", "v", "i" }, "<C-l>", "<cmd>bnext<cr>", { desc = "next buffer", remap = true })

-- navigate windows using the <ctrl> hjkl keys
-- vim.keymap.set({ "n", "i" }, "<C-S-h>", "<C-w>h", { desc = "left Window", remap = true })
-- vim.keymap.set({ "n", "i" }, "<C-S-j>", "<C-w>j", { desc = "lower Window", remap = true })
-- vim.keymap.set({ "n", "i" }, "<C-S-k>", "<C-w>k", { desc = "upper Window", remap = true })
-- vim.keymap.set({ "n", "i" }, "<C-S-l>", "<C-w>l", { desc = "right Window", remap = true })

vim.keymap.set("v", "<leader>p", '"_dP', { desc = "paste without yank" })

vim.api.nvim_create_autocmd("TextYankPost", { -- highlight when yanking (copying) text
	desc = "highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "wrap and check for spell in text fts",
	group = vim.api.nvim_create_augroup("wrap-spell", { clear = true }),
	pattern = { "text", "tex", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
--   desc = "refresh codelens for current buffer",
--   buffer = 0,
--   callback = function()
--     vim.lsp.codelens.refresh({ bufnr = 0 })
--   end,
-- })

vim.api.nvim_create_autocmd({ "InsertLeavePre", "TextChanged", "TextChangedP" }, {
	pattern = "*",
	desc = "auto-update buffer if modifiable and not readonly",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		if vim.bo[bufnr].modifiable and not vim.bo[bufnr].readonly then
			vim.cmd("silent! update")
		end
	end,
})
