require("lazydev").setup({
	library = {
		{ path = nixCats.nixCatsPath .. "lua", words = { "nixCats" } },
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})
