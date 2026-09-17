-- one file per tab: a file loaded into a window that was already showing another
-- file gets its own tab, and the window gets its former buffer (and view) back.
-- Watched on BufWinEnter, not BufAdd: BufAdd fires while the command that added
-- the buffer is still running, before the window has switched, so opening a tab
-- from there leaves duplicate/ghost tabs behind.
local tab_per_buffer = vim.api.nvim_create_augroup("OneFilePerTab", { clear = true })
-- what each window displayed before its buffer changed, and where it was
local prev_buf, prev_view = {}, {}
-- windows the current command created itself (:split, :vsplit, :tabnew, :new)
local fresh_win = {}
local relocating = false

local function is_file_buffer(buf)
  return type(buf) == "number"
    and buf > 0
    and vim.api.nvim_buf_is_valid(buf)
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

vim.api.nvim_create_autocmd("WinNew", {
  group = tab_per_buffer,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    fresh_win[win] = true
    -- only the command that created the window counts as explicit
    vim.schedule(function()
      fresh_win[win] = nil
    end)
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = tab_per_buffer,
  callback = function(args)
    if relocating then
      return
    end
    local win = vim.api.nvim_get_current_win()
    prev_buf[win] = args.buf
    prev_view[win] = vim.fn.winsaveview()
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  group = tab_per_buffer,
  callback = function(args)
    local win = tonumber(args.match)
    fresh_win[win], prev_buf[win], prev_view[win] = nil, nil, nil
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = tab_per_buffer,
  callback = function(args)
    local win
    for _, w in ipairs(vim.fn.win_findbuf(args.buf)) do
      -- ignore floating windows (previews, hovers, explorers)
      if vim.api.nvim_win_get_config(w).relative == "" and prev_buf[w] and prev_buf[w] ~= args.buf then
        win = w
      end
    end

    local old = win and prev_buf[win]
    -- nothing to do for scratch/special buffers, for a window the user created
    -- on purpose, or when the buffer being left is still on screen elsewhere
    if not win or relocating or fresh_win[win] then
      return
    end
    if not is_file_buffer(args.buf) or not is_file_buffer(old) or #vim.fn.win_findbuf(old) > 0 then
      return
    end

    -- run once the command that opened the buffer has finished, so positions set
    -- afterwards (LSP jumps, pickers) come along
    vim.schedule(function()
      if relocating or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= args.buf then
        return
      end
      relocating = true

      local pos = vim.api.nvim_win_get_cursor(win)
      vim.api.nvim_win_set_buf(win, old)
      local view = prev_view[win]
      if view then
        vim.api.nvim_win_call(win, function()
          vim.fn.winrestview(view)
        end)
      end

      local shown
      for _, w in ipairs(vim.fn.win_findbuf(args.buf)) do
        if w ~= win and vim.api.nvim_win_get_config(w).relative == "" then
          shown = w
        end
      end

      if shown then
        -- already displayed somewhere: jump there instead of duplicating it
        vim.api.nvim_set_current_win(shown)
      else
        vim.cmd("tab sbuffer " .. args.buf)
        vim.api.nvim_win_set_cursor(0, pos)
      end

      relocating = false
    end)
  end,
})

-- highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "wrap and check for spell in text fts",
  group = vim.api.nvim_create_augroup("wrap-spell", { clear = true }),
  pattern = { "text", "tex", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeavePre", "TextChanged", "TextChangedP" }, {
  pattern = "*",
  desc = "auto-update buffer if modifiable and not readonly",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].modifiable and not vim.bo[bufnr].readonly then
      vim.cmd("silent! update")
    end
  end,
})
