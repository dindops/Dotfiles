return {
  {'jakewvincent/mkdnflow.nvim',
  config = function()
    require('mkdnflow').setup({
      links = {
        style = 'markdown',
        name_is_source = false,
        conceal = false,
        context = 0,
        implicit_extension = nil,
        transform_implicit = false,
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          return(text)
        end
      },
    })
  end
  },
}
