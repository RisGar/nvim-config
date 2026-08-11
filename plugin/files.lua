local yazi = require("yazi")

vim.keymap.set("n", "<leader>e", function()
  yazi.yazi()
end)

vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    yazi.setup({
      open_for_directories = true,
      floating_window_scaling_factor = 0.8,
    })
  end,
})
