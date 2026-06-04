return {
  'emmanueltouzery/apidocs.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
  },
  cmd = { 'ApidocsSearch', 'ApidocsInstall', 'ApidocsOpen', 'ApidocsSelect', 'ApidocsUninstall' },
  config = function()
    require('apidocs').setup()
  end,
  keys = {
    { '<leader>sad', '<cmd>ApidocsOpen<cr>', desc = 'Search Api Doc' },
    { '<leader>gad', '<cmd>ApidocsSearch<cr>', desc = 'Search Api Doc' },
  },
}
