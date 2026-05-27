if not vim.g.typst_preview_setup_done then
	vim.cmd.packadd("typst-preview-nvim")
	require("typst-preview").setup({})
	vim.g.typst_preview_setup_done = true
end
