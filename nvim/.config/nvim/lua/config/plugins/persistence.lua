return {
  {'folke/persistence.nvim',
    event = 'BufRead',
    config = function()
      require('persistence').setup({
        dir = vim.fn.expand(vim.fn.stdpath 'state' .. '/sessions/'),
        options = { 'buffers', 'curdir', 'tabpages', 'winsize' }
      })
    end
  }
}
