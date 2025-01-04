return {
  {'ellisonleao/gruvbox.nvim'},
  {'Mofiqul/dracula.nvim'},
  {'svrana/neosolarized.nvim',
  config = function()
    require("neosolarized").setup({
      comment_italics = true,
      background_set = false,
    })
    vim.cmd.colorscheme("neosolarized")
  end,
  dependencies = {
    {'tjdevries/colorbuddy.nvim'},
  }
},
}
