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
  print(line_text)
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
  task_tag = task_tag or "inbox"
  print(task_tag, task_description)

    -- Ask for project and other tags
  local project = vim.fn.input "Enter project name: "
  local additional_tags_input = vim.fn.input "Enter additional tags separated by spaces: "
  local additional_tags = {}

  -- Prefix each additional tag with a "+"
  for tag in additional_tags_input:gmatch "%S+" do
    table.insert(additional_tags, "+" .. tag)
  end

  -- Construct the Taskwarrior command
  -- Example: task add "This is the TODO text" +code nvimline:145:/home/user/file.lua
  local task_cmd = string.format(
    'task add %s "%s"',
    task_tag,
    task_description
  )

  -- Add additional tags if available
  if #additional_tags > 0 then
    task_cmd = task_cmd .. " " .. table.concat(additional_tags, " ")
  end

  -- Add project if available
  if project and #project > 0 then
    task_cmd = task_cmd .. " project:" .. project
  end

  -- Create task and then annotate it (currently annotations can be added after task creation)
  local output = vim.fn.system(task_cmd)
  print("Output: ", output)

  for line in output:gmatch "[^\r\n]+" do
    local task_id = string.match(line, "Created task (%d+)%.")
    if task_id then
      print("Task ID extracted: ", task_id)

      -- Annotate task with filename and line number in the nvimline format
      local nvimline_annotation = string.format("nvimline:%d:%s", line_nr, file_path)
      local annotate_cmd = string.format('task %s annotate "%s"', task_id, nvimline_annotation)
      local annotate_output = vim.fn.system(annotate_cmd)
      print("Annotation output: ", annotate_output)
      return
    else
      print "Failed to extract task ID"
    end
  end
end

vim.api.nvim_set_keymap(
  'n',
  '<C-t>',
  [[<cmd>lua require('config.taskwarrior').create_taskwarrior_task()<CR>]],
  { noremap = true, silent = true }
)

return M
