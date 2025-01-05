return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', function()
        builtin.find_files({hidden=true})
      end, {}
      )
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
      vim.keymap.set('n', '<leader>gs', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") });
      end)
    end
  }
}
