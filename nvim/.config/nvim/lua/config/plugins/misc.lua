return {
  'tpope/vim-fugitive',
  'tpope/vim-commentary',
  'Yggdroot/indentLine',
  'hashivim/vim-terraform',
  'mbbill/undotree',
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}
}
