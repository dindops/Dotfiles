return {
  {
    "olimorris/codecompanion.nvim",
    version = "^18.0.0",
    opts = {
        interactions = {
          chat = {
            -- You can specify an adapter by name and model (both ACP and HTTP)
            adapter = {
              name = "anthropic",
              model = "claude-sonnet-4-5-20250929",
            },
          },
          -- Or, just specify the adapter by name
          inline = {
            adapter = {
              name = "anthropic",
              model = "claude-sonnet-4-5-20250929",
            },
          },
          cmd = {
            adapter = {
              name = "anthropic",
              model = "claude-sonnet-4-5-20250929",
            },
          },
          background = {
            adapter = {
              name = "anthropic",
              model = "claude-haiku-4-5-20251001",
            },
          },
        },
      },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
