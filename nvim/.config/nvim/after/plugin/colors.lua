function ColorschemeSetup(color)
	color = color or "dracula"
	vim.cmd.colorscheme(color)
	vim.o.termguicolors = true
  -- require('neosolarized').setup({
  --   comment_italics = true,
  --   background_set = true
  -- })

end

ColorschemeSetup()

