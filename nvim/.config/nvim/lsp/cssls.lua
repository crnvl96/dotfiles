vim.lsp.config('cssls', {
  settings = {
    css = {
      validate = true,
      format = true,
      newlineBetweenRules = true,
      newlineBetweenSelectors = true,
      spaceAroundSelectorSeparator = true,
    },
    scss = { validate = true },
    less = { validate = true },
  },
})
