vim.cmd.packadd("render-markdown-nvim")
require("render-markdown").setup({
	preset = "obsidian",
	completions = { blink = { enabled = true } },
	code = {
		sign = false,
	},
	heading = {
		position = "inline",
	},
	html = {
		comment = {
			conceal = false,
		},
	},
	latex = {
		enabled = false,
	},
	file_types = { "markdown" },
})
