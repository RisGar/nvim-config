-- all new buffers as tabs
vim.api.nvim_create_autocmd("BufAdd", {
  group = vim.api.nvim_create_augroup("OpenNewBufferInTab", { clear = true }),
  callback = function(args)
    -- Ignore unlisted buffers or special filetypes (like quickfix or NvimTree)
    if not vim.bo[args.buf].buflisted or vim.bo[args.buf].buftype ~= "" then
      return
    end

    -- Skip if we are already in an empty/unnamed single-buffer session
    local cur_buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(cur_buf) == "" and vim.bo[cur_buf].filetype == "" then
      return
    end

    -- Open the newly added buffer in a new tab page
    vim.cmd("tabnew " .. vim.fn.fnameescape(vim.api.nvim_buf_get_name(args.buf)))
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
