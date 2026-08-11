-- snacks.nvim
require("snacks").setup({
  toggle = { enabled = true },
})

Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.diagnostics():map("<leader>ud")

local tsc = require("treesitter-context")
Snacks.toggle({
  name = "treesitter context",
  get = tsc.enabled,
  set = function(state)
    if state then
      tsc.enable()
    else
      tsc.disable()
    end
  end,
}):map("<leader>ut")

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
-- 	Snacks.picker.command_history()
-- end, { desc = "Cmd History" })

-- -- Find
-- vim.keymap.set("n", "<leader>fg", function()
-- 	Snacks.picker.git_files()
-- end, { desc = "Git Find" })
-- vim.keymap.set("n", "<leader>f.", function()
-- 	Snacks.picker.recent()
-- end, { desc = "Recents" })
-- vim.keymap.set("n", "<leader>fc", function()
-- 	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
-- end, { desc = "Find Config" })
-- vim.keymap.set("n", "<leader>fp", function()
-- 	Snacks.picker.projects()
-- end, { desc = "Projects" })

-- -- Git
-- vim.keymap.set("n", "<leader>gl", function()
-- 	Snacks.picker.git_log()
-- end, { desc = "Git Log" })
-- vim.keymap.set("n", "<leader>gL", function()
-- 	Snacks.picker.git_log_line()
-- end, { desc = "Git Log Line" })
-- vim.keymap.set("n", "<leader>gf", function()
-- 	Snacks.picker.git_log_file()
-- end, { desc = "Git Log File" })
-- vim.keymap.set("n", "<leader>gb", function()
-- 	Snacks.picker.git_branches()
-- end, { desc = "Git Branches" })
-- vim.keymap.set("n", "<leader>gs", function()
-- 	Snacks.picker.git_status()
-- end, { desc = "Git Status" })
-- vim.keymap.set("n", "<leader>gS", function()
-- 	Snacks.picker.git_stash()
-- end, { desc = "Git Stash" })
-- vim.keymap.set("n", "<leader>gd", function()
-- 	Snacks.picker.git_diff()
-- end, { desc = "Git Diff (Hunks)" })

-- -- Search
-- vim.keymap.set("n", "<leader>su", function()
-- 	Snacks.picker.undo()
-- end, { desc = "Undo History" })
-- vim.keymap.set("n", "<leader>sh", function()
-- 	Snacks.picker.help()
-- end, { desc = "Help Pages" })
-- vim.keymap.set("n", "<leader>sk", function()
-- 	Snacks.picker.keymaps()
-- end, { desc = "Keymaps" })
-- vim.keymap.set("n", "<leader>sc", function()
-- 	Snacks.picker.command_history()
-- end, { desc = "Cmd History" })
-- vim.keymap.set("n", "<leader>s/", function()
-- 	Snacks.picker.search_history()
-- end, { desc = "Search History" })
-- vim.keymap.set("n", "<leader>sC", function()
-- 	Snacks.picker.commands()
-- end, { desc = "Commands" })
-- vim.keymap.set("n", "<leader>ss", function()
-- 	Snacks.picker.lsp_symbols()
-- end, { desc = "LSP Symbols" })
-- vim.keymap.set("n", "<leader>sS", function()
-- 	Snacks.picker.lsp_workspace_symbols()
-- end, { desc = "LSP Workspace Symbols" })
-- vim.keymap.set("n", "<leader>sd", function()
-- 	Snacks.picker.diagnostics()
-- end, { desc = "Diagnostics" })
-- vim.keymap.set("n", "<leader>sD", function()
-- 	Snacks.picker.diagnostics_buffer()
-- end, { desc = "Buffer Diagnostics" })

-- LSP Gotos
-- vim.keymap.set("n", "gd", function()
-- 	Snacks.picker.lsp_definitions()
-- end, { desc = "Goto Definition" })
-- vim.keymap.set("n", "gr", function()
-- 	Snacks.picker.lsp_references()
-- end, { desc = "References", nowait = true })
-- vim.keymap.set("n", "gI", function()
-- 	Snacks.picker.lsp_implementations()
-- end, { desc = "goto implementation" })
-- vim.keymap.set("n", "gy", function()
-- 	Snacks.picker.lsp_type_definitions()
-- end, { desc = "Goto Type Definition" })

-- Words
vim.keymap.set({ "n", "t" }, "]]", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Next Reference" })
vim.keymap.set({ "n", "t" }, "[[", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev Reference" })

-- Easily quit tv.nvim windows
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tv",
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
    vim.keymap.set({ "n", "t" }, "<Esc>", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})
