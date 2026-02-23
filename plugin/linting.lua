if vim.g.vscode then
	return {}
end

require("lint").linters_by_ft = {
	fish = { "fish" },
	markdown = { "markdownlint-cli2" },
	nix = { "statix" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
