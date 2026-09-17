vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Up>", "<Nop>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "exit terminal mode" }) -- exit terminal mode

vim.keymap.set({ "n", "v", "i" }, "<C-h>", "<cmd>tabprevious<cr>", { desc = "previous tab", remap = true })
vim.keymap.set({ "n", "v", "i" }, "<C-l>", "<cmd>tabnext<cr>", { desc = "next tab", remap = true })

vim.keymap.set("v", "<leader>p", '"_dP', { desc = "paste without yank" })
