-- Inlay Hints & Diagnostics
vim.keymap.set("n", "<leader>uh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "toggle inlay hints" })

vim.keymap.set("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "toggle diagnostics" })

vim.keymap.set("n", "<leader>ut", function()
  require("treesitter-context").toggle()
end, { desc = "toggle treesitter context" })

-- Picker

local fzf = require("fzf-lua")
fzf.setup({ "fzf-tmux" })
fzf.register_ui_select()

-- Quick Keybinds

vim.keymap.set("n", "<leader><leader>", fzf.global, { desc = "global" })
vim.keymap.set("n", "<leader>f", fzf.files, { desc = "file" })
-- vim.keymap.set("n", "<leader>.", fzf.buffers, { desc = "buffer" })
vim.keymap.set("n", "<leader>.", fzf.tabs, { desc = "tabs" })
vim.keymap.set("n", "<leader>/", fzf.live_grep_native, { desc = "file" })
vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "command history" })

-- Alls

vim.keymap.set("n", "<leader>s.", fzf.history, { desc = "history" })
vim.keymap.set("n", "<leader>s/", fzf.search_history, { desc = "search history" })
vim.keymap.set("n", "<leader>sc", fzf.commands, { desc = "commands" })
vim.keymap.set("n", "<leader>sv", fzf.vcs_files, { desc = "vcs files" })
vim.keymap.set("n", "<leader>su", fzf.undotree, { desc = "undo tree" })
vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "keymaps" })
vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "help" })
vim.keymap.set("n", "<leader>sm", fzf.manpages, { desc = "manpages" })
vim.keymap.set("n", "<leader>sj", fzf.jumps, { desc = "jumps" })
vim.keymap.set("n", "<leader>so", fzf.nvim_options, { desc = "nvim options" })

-- LSPs
vim.keymap.set("n", "<leader>sl", fzf.lsp_finder, { desc = "lsp" })
vim.keymap.set("n", "<leader>ss", fzf.lsp_document_symbols, { desc = "document symbols" })
vim.keymap.set("n", "<leader>sS", fzf.lsp_live_workspace_symbols, { desc = "workspace symbols" })

-- Diagnostics

vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "document diagnostics" })
vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "workspace diagnostics" })

-- LSP Actions

vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "references" })
vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "definitions" })
vim.keymap.set("n", "gD", fzf.lsp_declarations, { desc = "declarations" })
vim.keymap.set("n", "gy", fzf.lsp_typedefs, { desc = "type definitions" })
vim.keymap.set("n", "gI", fzf.lsp_implementations, { desc = "implementations" })

-- TODO: DAP
