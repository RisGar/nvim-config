vim.cmd.packadd("vimtex")

vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
vim.g.vimtex_view_method = "zathura"

vim.keymap.set("nv", "<LocalLeader>l", "<Nop>", { buffer = true, desc = "+vimtex" })
vim.keymap.set("nv", "<leader>K", "<plug>(vimtex-doc-package)", { desc = "vimtex docs", silent = true })
