vim.lsp.config('efm', {
  root_dir = function(bufnr, on_dir)
    if not bufnr then
      return
    end
    local ft = vim.bo[bufnr].filetype

    if not ft then
      return
    end

    local languages = {
      lua = { 'stylua.toml' },
      typescript = { 'package.json' },
    }

    local root = vim.fs.root(bufnr, languages[ft])
    if root then
      on_dir(root)
    end
  end,
  init_options = { documentFormatting = true },
  settings = {
    languages = {
      lua = {
        {
          formatStdin = true,
          formatCommand = 'stylua --search-parent-directories --respect-ignores --stdin-filepath \'${INPUT}\' -',
        },
      },
      typescript = {
        {
          formatStdin = true,
          formatCommand = 'prettierd \'${INPUT}\'',
        },
      },
    },
  },
})
