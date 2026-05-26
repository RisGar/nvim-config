if vim.g.vscode then
	return {}
end

require("lint").linters_by_ft = {
	markdown = { "markdownlint-cli2" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
