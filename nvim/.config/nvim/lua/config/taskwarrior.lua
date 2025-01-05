-- config heavily inspired by Cloud-Native Corner (https://github.com/Piotr1215/dotfiles/blob/master/.config/nvim/lua/user_functions/tasks.lua)

local M = {}

local function trim(s)
  return s:match('^%s*(.-)%s*$')
end

--- Create a task in Taskwarrior from the current line
function M.create_taskwarrior_task()
  local line_nr = vim.fn.line "."
  local file_path = vim.fn.expand "%:p"
  local line_text = vim.fn.getline "."
  local keywords = { "TODO", "FIXME", "NOTE" }
  line_text = trim(line_text)
  local task_description
  local task_tag
  for _, keyword in ipairs(keywords) do
    local start_index, end_index = string.find(line_text, keyword)
    if start_index then
      task_description = string.sub(line_text, end_index + 2)
      task_tag = "+" .. string.lower(keyword)
      break
    end
  end
  task_description = task_description or line_text
  task_tag = task_tag or "+todo"

  local project = vim.fn.input "Enter project name: "
  local additional_tags_input = vim.fn.input "Enter additional tags separated by spaces: "
  local additional_tags = {}

  for tag in additional_tags_input:gmatch "%S+" do
    table.insert(additional_tags, "+" .. tag)
  end

  -- Construct the Taskwarrior command
  local task_cmd = string.format(
    'task add %s "%s"',
    task_tag,
    task_description
  )

  if #additional_tags > 0 then
    task_cmd = task_cmd .. " " .. table.concat(additional_tags, " ")
  end

  local nvimline_annotation = string.format("nvimline:%d:%s", line_nr, file_path)
  task_cmd = task_cmd .. " " .. nvimline_annotation

  if project and #project > 0 then
    task_cmd = task_cmd .. " project:" .. project
  end

  local output = vim.fn.system(task_cmd)
  print("Output: ", output)
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>ta',
  [[<cmd>lua require('config.taskwarrior').create_taskwarrior_task()<CR>]],
  { noremap = true, silent = true }
)

return M
