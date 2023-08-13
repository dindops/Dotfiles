-- My own, boring statusline
-- Inspired by https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html

local function mode()
  local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
  }
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(" %s ", modes[current_mode]):upper()
end

local function lineinfo()
  -- %p - Percentage through the file.
  -- %l - Line Number
  -- %c - Column Number
  return " %p%% %l:%c "
end

local function filepath()
  local avoided_filetypes = {
    ["help"]=true,
    ["fugitive"]=true
  }
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if fpath == "" or fpath == "." or avoided_filetypes[vim.bo.filetype] then
      return " "
  end
  return string.format("%%<%s/", fpath)
end

local function filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" or vim.bo.filetype == "help" then
      return ""
  end
  return fname .. " "
end

local function lsp_stats()
  local count = {}
  local levels = {
    errors = "Error",
    warnings = "Warn",
    info = "Info",
    hints = "Hint",
  }
  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end
  local errors = ""
  local warnings = ""
  local hints = ""
  local info = ""
  if count["errors"] ~= 0 then
    errors = " E: " .. count["errors"]
  end
  if count["warnings"] ~= 0 then
    -- warnings = " %#LspDiagnosticsSignWarning#W: " .. count["warnings"]
    warnings = " W: " .. count["warnings"]
  end
  if count["hints"] ~= 0 then
    hints = " H: " .. count["hints"]
  end
  if count["info"] ~= 0 then
    info = " I: " .. count["info"]
  end
  return errors .. warnings .. hints .. info .. " "
end

local function filetype()
  return string.format(" %s ", vim.bo.filetype)
end

local function show_git_branch()
    local fugitive_status = vim.fn["fugitive#statusline"]():match("%((%S*)%)") or ""
    if (string.len(fugitive_status) >= 1) then
      return string.format(" [%s] ", fugitive_status)
    else
      return ""
    end
end

Statusline = {}
Statusline.activate = function()
  return table.concat {
  "%#StatusLine#",
  mode(),
  "%#WinBar#",
  show_git_branch(),
  "%#Normal# ",
  filepath(),
  filename(),
  "%=",
  "%#Title#",
  lsp_stats(),
  "%#WinBar#",
  filetype(),
  "%#TabLine#",
  lineinfo(),
  }
end

vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.activate()
  augroup END
]], false)

vim.opt.laststatus = 3  -- 3 means global statusline
