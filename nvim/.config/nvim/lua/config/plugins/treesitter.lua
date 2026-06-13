return {
  {'nvim-treesitter/nvim-treesitter',
    branch = "main",
    build = ":TSUpdate",
    config = function()
      vim.schedule(function()
        require('nvim-treesitter').install({
          "bash", "c", "dockerfile", "fish", "go", "hcl", "json", "lua",
          "markdown", "markdown_inline", "python", "query", "vim", "yaml",
        })
      end)
    end,
  }
}
