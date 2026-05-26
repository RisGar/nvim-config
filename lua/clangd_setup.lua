require("clangd_extensions").setup({
	ast = {
		role_icons = {
			type = "",
			declaration = "",
			expression = "",
			specifier = "",
			statement = "",
			["template argument"] = "",
		},

		kind_icons = {
			Compound = "",
			Recovery = "",
			TranslationUnit = "",
			PackExpansion = "",
			TemplateTypeParm = "",
			TemplateTemplateParm = "",
			TemplateParamObject = "",
		},
	},
	memory_usage = {
		border = "rounded",
	},
	symbol_info = {
		border = "rounded",
	},
})
