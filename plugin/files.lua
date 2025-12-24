if vim.g.vscode then
	return {}
end

require("oil").setup({
	delete_to_trash = true,
	view_options = { show_hidden = true },
	float = { max_width = 0.8, max_height = 0.8, border = "rounded" },
	keymaps = {
		["gd"] = {
			desc = "Toggle file detail view",
			callback = function()
				Detail = not Detail
				if Detail then
					require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
				else
					require("oil").set_columns({
						"icon",
					})
				end
			end,
		},
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "File Explorer" })
