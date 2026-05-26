-- One Dark Pro
require("onedarkpro").setup({
	options = {
		transparency = true,
		cursorline = true,
	},
	highlights = {
		SnacksIndentScope = { fg = "${fg}" },
		Cursor = { bg = "#5188FA", fg = "${white}" },
	},
	styles = {
		comments = "italic",
		keywords = "bold",
	},
})
vim.cmd.colorscheme("onedark")

-- Lualine
require("lualine").setup({
	options = {
		component_separators = "",
		section_separators = "",
	},
})
