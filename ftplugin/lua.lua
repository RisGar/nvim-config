vim.cmd.packadd("lazydev.nvim")
require("lazydev").setup({
	library = {
		-- nixCats
		{ path = nixCats.nixCatsPath and nixCats.nixCatsPath .. "lua" or nil, words = { "nixCats" } },
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
