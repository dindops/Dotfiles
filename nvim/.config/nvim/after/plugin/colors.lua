function ColorschemeSetup(color)
	color = color or "dracula"
	vim.cmd.colorscheme(color)
	vim.o.termguicolors = true
end

ColorschemeSetup()

