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

-- Fuzzy Finders
require("tv").setup({
  window = {
    border = "rounded",
  },
  channels = {
    files = {
      keybinding = "<leader><leader>",
      args = { "--no-status-bar", "--preview-size", "50" },
    },
    text = {
      keybinding = "<leader>/",
      args = { "--no-status-bar", "--preview-size", "50" },
    },
    ["todo-comments"] = {
      keybinding = "<leader>st",
      args = { "--no-status-bar", "--preview-size", "50" },
    },
  },
  tv_binary = "tv",
  quickfix = {
    auto_open = true,
  },
  global_keybindings = {
    channels = "<leader>tv",
  },
})

local function tv_buffers()
  local bufs = vim.api.nvim_list_bufs()
  local buf_names = {}
  local cwd = vim.fn.getcwd() .. "/"

  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local rel_name = name:gsub("^" .. vim.pesc(cwd), "")
        table.insert(buf_names, rel_name)
      end
    end
  end

  if #buf_names == 0 then
    vim.notify("No active buffers.", vim.log.levels.INFO)
    return
  end

  local escaped_buffers = vim.fn.shellescape(table.concat(buf_names, "\n"))
  local tv_config = require("tv.config")
  tv_config.current.channels = tv_config.current.channels or {}
  tv_config.current.channels.files = tv_config.current.channels.files or {}

  local original_binary = tv_config.current.tv_binary
  local original_args = tv_config.current.channels.files.args

  tv_config.current.tv_binary = "sh"
  tv_config.current.channels.files.args = {
    "-c",
    "printf '%s\\n' " .. escaped_buffers .. " | " .. (original_binary or "tv") .. ' "$@"',
    "--",
    "--preview-command",
    "bat -n --color=always {}",
    "--no-status-bar",
    "--preview-size",
    "50",
  }

  require("tv").tv_channel("files")

  tv_config.current.tv_binary = original_binary
  tv_config.current.channels.files.args = original_args
end

vim.keymap.set("n", "<leader>.", tv_buffers, { desc = "buffers" })

-- vim.keymap.set("n", "<leader>:", function()
-- end, { desc = "Cmd History" })

-- -- Find
-- vim.keymap.set("n", "<leader>fg", function()
-- end, { desc = "Git Find" })
-- vim.keymap.set("n", "<leader>f.", function()
-- end, { desc = "Recents" })
-- vim.keymap.set("n", "<leader>fc", function()
-- end, { desc = "Find Config" })
-- vim.keymap.set("n", "<leader>fp", function()
-- end, { desc = "Projects" })

-- -- Git
-- vim.keymap.set("n", "<leader>gl", function()
-- end, { desc = "Git Log" })
-- vim.keymap.set("n", "<leader>gL", function()
-- end, { desc = "Git Log Line" })
-- vim.keymap.set("n", "<leader>gf", function()
-- end, { desc = "Git Log File" })
-- vim.keymap.set("n", "<leader>gb", function()
-- end, { desc = "Git Branches" })
-- vim.keymap.set("n", "<leader>gs", function()
-- end, { desc = "Git Status" })
-- vim.keymap.set("n", "<leader>gS", function()
-- end, { desc = "Git Stash" })
-- vim.keymap.set("n", "<leader>gd", function()
-- end, { desc = "Git Diff (Hunks)" })

-- -- Search
-- vim.keymap.set("n", "<leader>su", function()
-- end, { desc = "Undo History" })
-- vim.keymap.set("n", "<leader>sh", function()
-- end, { desc = "Help Pages" })
-- vim.keymap.set("n", "<leader>sk", function()
-- end, { desc = "Keymaps" })
-- vim.keymap.set("n", "<leader>sc", function()
-- end, { desc = "Cmd History" })
-- vim.keymap.set("n", "<leader>s/", function()
-- end, { desc = "Search History" })
-- vim.keymap.set("n", "<leader>sC", function()
-- end, { desc = "Commands" })
-- vim.keymap.set("n", "<leader>ss", function()
-- end, { desc = "LSP Symbols" })
-- vim.keymap.set("n", "<leader>sS", function()
-- end, { desc = "LSP Workspace Symbols" })
-- vim.keymap.set("n", "<leader>sd", function()
-- end, { desc = "Diagnostics" })
-- vim.keymap.set("n", "<leader>sD", function()
-- end, { desc = "Buffer Diagnostics" })

-- LSP Gotos
-- vim.keymap.set("n", "gd", function()
-- end, { desc = "Goto Definition" })
-- vim.keymap.set("n", "gr", function()
-- end, { desc = "References", nowait = true })
-- vim.keymap.set("n", "gI", function()
-- end, { desc = "goto implementation" })
-- vim.keymap.set("n", "gy", function()
-- end, { desc = "Goto Type Definition" })

-- Easily quit tv.nvim windows
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tv",
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    vim.keymap.set({ "n", "t" }, "<Esc>", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})
