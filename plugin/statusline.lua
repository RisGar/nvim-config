-- Define mode names and highlight groups to use for their colors
local modes = {
  ["n"]  = { "NORMAL", "Normal" },
  ["no"] = { "O-PENDING", "Normal" },
  ["nov"] = { "O-PENDING", "Normal" },
  ["noV"] = { "O-PENDING", "Normal" },
  ["no\22"] = { "O-PENDING", "Normal" },
  ["niI"] = { "NORMAL", "Normal" },
  ["niR"] = { "NORMAL", "Normal" },
  ["niV"] = { "NORMAL", "Normal" },
  ["nt"] = { "NORMAL", "Normal" },
  ["ntT"] = { "NORMAL", "Normal" },
  ["v"]  = { "VISUAL", "Visual" },
  ["vs"] = { "VISUAL", "Visual" },
  ["V"]  = { "V-LINE", "Visual" },
  ["Vs"] = { "V-LINE", "Visual" },
  ["\22"] = { "V-BLOCK", "Visual" },
  ["\22s"] = { "V-BLOCK", "Visual" },
  ["s"]  = { "SELECT", "Visual" },
  ["S"]  = { "S-LINE", "Visual" },
  ["\19"] = { "S-BLOCK", "Visual" },
  ["i"]  = { "INSERT", "Insert" },
  ["ic"] = { "INSERT", "Insert" },
  ["ix"] = { "INSERT", "Insert" },
  ["R"]  = { "REPLACE", "Replace" },
  ["Rc"] = { "REPLACE", "Replace" },
  ["Rx"] = { "REPLACE", "Replace" },
  ["Rv"] = { "V-REPLACE", "Replace" },
  ["Rvc"] = { "V-REPLACE", "Replace" },
  ["Rvx"] = { "V-REPLACE", "Replace" },
  ["c"]  = { "COMMAND", "Command" },
  ["cv"] = { "EX", "Command" },
  ["ce"] = { "EX", "Command" },
  ["r"]  = { "REPLACE", "Replace" },
  ["rm"] = { "MORE", "Normal" },
  ["r?"] = { "CONFIRM", "Normal" },
  ["x"]  = { "CONFIRM", "Normal" },
  ["!"]  = { "SHELL", "Normal" },
  ["t"]  = { "TERMINAL", "Normal" },
}

-- Cache to avoid redefining icon highlight groups on every render
local icon_hl_cache = {}

local function setup_highlights()
  -- Helper to get hex color from highlight group
  local function get_hl_color(hl_group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
    if hl[attr] then
      return string.format("#%06x", hl[attr])
    end

    if hl_group ~= "StatusLine" and hl_group ~= "Normal" then
        local fallback = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
        if fallback[attr] then
            return string.format("#%06x", fallback[attr])
        end
    end

    return attr == "bg" and "#3b4252" or "#d8dee9"
  end

  local bg = get_hl_color("StatusLine", "bg")
  local fg = get_hl_color("StatusLine", "fg")

  -- Darker background for components
  local darker_bg = get_hl_color("StatusLineNC", "bg")

  -- Use standard syntax colors for modes if available
  local colors = {
    Normal = get_hl_color("String", "fg"), -- Often green
    Visual = get_hl_color("Statement", "fg"), -- Often purple/blue
    Insert = get_hl_color("Function", "fg"), -- Often blue
    Replace = get_hl_color("Error", "fg"), -- Often red
    Command = get_hl_color("WarningMsg", "fg"), -- Often yellow/orange
  }

  -- If colors couldn't be extracted nicely, use some sensible fallbacks
  if not colors.Normal or colors.Normal == "#d8dee9" then colors.Normal = "#a3be8c" end
  if not colors.Visual or colors.Visual == "#d8dee9" then colors.Visual = "#b48ead" end
  if not colors.Insert or colors.Insert == "#d8dee9" then colors.Insert = "#81a1c1" end
  if not colors.Replace or colors.Replace == "#d8dee9" then colors.Replace = "#bf616a" end
  if not colors.Command or colors.Command == "#d8dee9" then colors.Command = "#ebcb8b" end

  for mode_hl, color in pairs(colors) do
    vim.api.nvim_set_hl(0, "StatusLineMode" .. mode_hl, { bg = color, fg = "#2e3440", bold = true })
  end

  vim.api.nvim_set_hl(0, "StatusLineGit", { bg = darker_bg, fg = colors.Normal })
  vim.api.nvim_set_hl(0, "StatusLineGitChanges", { bg = darker_bg, fg = colors.Replace })
  vim.api.nvim_set_hl(0, "StatusLineFile", { bg = bg, fg = fg })

  vim.api.nvim_set_hl(0, "StatusLineIcon", { bg = bg, fg = fg })

  vim.api.nvim_set_hl(0, "StatusLineRightInfo", { bg = bg, fg = fg })
  vim.api.nvim_set_hl(0, "StatusLinePosBg", { bg = darker_bg, fg = fg })
  vim.api.nvim_set_hl(0, "StatusLinePosFg", { bg = colors.Normal, fg = "#2e3440", bold = true })
end

-- Refresh highlights when colorscheme changes
local statusline_highlights_augroup = vim.api.nvim_create_augroup("StatusLineHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = statusline_highlights_augroup,
  callback = function()
    icon_hl_cache = {}
    setup_highlights()
  end,
})

-- Initialize highlights
setup_highlights()

local function get_git_info()
  local dict = vim.b.gitsigns_status_dict
  if not dict or not dict.head then
    return ""
  end

  local branch = string.format("%%#StatusLineGit#  %s ", dict.head)

  local changes = ""
  local added = dict.added and dict.added > 0 and ("+" .. dict.added) or ""
  local changed = dict.changed and dict.changed > 0 and ("~" .. dict.changed) or ""
  local removed = dict.removed and dict.removed > 0 and ("-" .. dict.removed) or ""

  -- The user's screenshot had a single red "-4", which might just be gitsigns_status.
  -- We'll combine them if they exist.
  local status_parts = {}
  if added ~= "" then table.insert(status_parts, added) end
  if changed ~= "" then table.insert(status_parts, changed) end
  if removed ~= "" then table.insert(status_parts, removed) end

  if #status_parts > 0 then
    -- Using StatusLineGitChanges which we made red-ish
    changes = "%%#StatusLineGitChanges#" .. table.concat(status_parts, " ") .. " "
  end

  return branch .. changes .. "%#StatusLine#"
end

local function get_file_info()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    filename = "[No Name]"
  else
    filename = filename:gsub("%%", "%%%%") -- Escape % for statusline
  end
  local modified = vim.bo.modified and " [+]" or ""
  local readonly = vim.bo.readonly and " [RO]" or ""
  return string.format(" %%#StatusLineFile#%s%s%s ", filename, modified, readonly)
end

local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local function get_file_type_icon()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  local icon = ""
  local icon_color = ""
  if has_devicons then
    icon, icon_color = devicons.get_icon_color(filename, extension, { default = true })
    if icon and icon_color then
      local hl_group = "StatusLineIcon_" .. extension

      -- Only create dynamic highlight group if it hasn't been created yet
      if not icon_hl_cache[hl_group] then
        vim.api.nvim_set_hl(0, hl_group, { fg = icon_color, bg = vim.api.nvim_get_hl(0, {name="StatusLine", link=false}).bg })
        icon_hl_cache[hl_group] = true
      end

      return string.format(" %%#%s#%s %%#StatusLineRightInfo#%s ", hl_group, icon, vim.bo.filetype)
    end
  end

  if vim.bo.filetype ~= "" then
    return string.format(" %%#StatusLineRightInfo#%s ", vim.bo.filetype)
  end
  return ""
end

local function get_file_encoding()
  local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
  return string.format(" %%#StatusLineRightInfo#%s ", enc)
end

local function get_file_format()
  local format = vim.bo.fileformat
  local icons = {
    unix = "", -- linux icon
    dos = "", -- windows icon
    mac = "", -- mac icon
  }
  local icon = icons[format] or format
  return string.format(" %%#StatusLineRightInfo#%s ", icon)
end

local function get_scroll_progress()
  local curr_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  if curr_line == 1 then
    return " Top "
  elseif curr_line == total_lines then
    return " Bot "
  else
    local percent = math.floor((curr_line / total_lines) * 100)
    return string.format(" %2d%%%% ", percent)
  end
end

local function get_mode()
  local mode_code = vim.api.nvim_get_mode().mode
  local mode_info = modes[mode_code] or { "UNKNOWN", "Normal" }
  local mode_name = mode_info[1]
  local mode_hl = "StatusLineMode" .. mode_info[2]

  return string.format("%%#%s# %s ", mode_hl, mode_name)
end

_G.StatusLine = function()
  -- Check if window is active
  local is_active = vim.g.statusline_winid == vim.api.nvim_get_current_win()

  if not is_active then
    return "%#StatusLineNC# %f %m%r %="
  end

  local statusline = {}

  -- Left side
  table.insert(statusline, get_mode())
  table.insert(statusline, get_git_info())
  table.insert(statusline, get_file_info())

  -- Middle padding
  table.insert(statusline, "%=")

  -- Right side
  table.insert(statusline, get_file_encoding())
  table.insert(statusline, get_file_format())
  table.insert(statusline, get_file_type_icon())
  table.insert(statusline, "%#StatusLinePosBg#")
  table.insert(statusline, get_scroll_progress())
  table.insert(statusline, "%#StatusLinePosFg# %l:%c ")

  return table.concat(statusline, "")
end

vim.opt.statusline = "%!v:lua.StatusLine()"
