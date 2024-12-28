function ColorschemeSetup(color)
  color = color or "neosolarized"
  vim.cmd.colorscheme(color)
  vim.o.termguicolors = true
  require('neosolarized').setup({
    comment_italics = true,
    background_set = false
  })

end

ColorschemeSetup()
