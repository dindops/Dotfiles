function ColorschemeSetup(color)
  color = color or "neosolarized"
  vim.cmd.colorscheme(color)
  vim.o.termguicolors = true
end

ColorschemeSetup()
