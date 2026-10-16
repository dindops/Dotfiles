vim.keymap.set("n", "<leader>b", "i**<ESC>Ea**<ESC>")
vim.keymap.set("n", "<leader>i", "i*<ESC>Ea*<ESC>")
vim.keymap.set("n", "<leader>c", "I```<ESC>o```<ESC>ka<Space>")

vim.keymap.set("n", "<leader><leader>", function()
  require("mkdnflow.to_do").toggle_to_do()
end, { buffer = true, desc = "Toggle/create checklist item" })
