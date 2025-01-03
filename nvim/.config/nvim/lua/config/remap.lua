vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- better copy-buffer management
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>Y", "\"+Y")

vim.keymap.set("n", "Q", "<nop")

-- Easier movement between splits
vim.keymap.set("n", "<C-j>", "<C-W><C-j>")
vim.keymap.set("n", "<C-k>", "<C-W><C-k>")
vim.keymap.set("n", "<C-l>", "<C-W><C-l>")
vim.keymap.set("n", "<C-h>", "<C-W><C-h>")

vim.keymap.set("n", "<F8>", ":setlocal spell! spelllang=en_gb,pl<CR>")
