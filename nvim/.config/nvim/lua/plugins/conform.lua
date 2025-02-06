Add('stevearc/conform.nvim')

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  formatters = { injected = { ignore_errors = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    lua = { 'stylua' },
    css = { 'prettierd' },
    html = { 'prettierd' },
    scss = { 'prettierd' },
    json = { 'prettierd' },
    jsonc = { 'prettierd' },
    yaml = { 'yamlfmt' },
    yml = { 'yamlfmt' },
    toml = { 'taplo' },
    markdown = { 'prettierd', 'injected' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
    typescript = function(bufnr)
      if bufnr and vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' }) then
        return { 'biome', 'biome-check', 'biome-organize-imports' }
      else
        return { 'prettierd' }
      end
    end,
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
    return { timeout_ms = 3000, lsp_format = 'fallback' }
  end,
})

Utils.User('Format', function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end
  require('conform').format({
    range = range,
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = 'fallback',
  })
end, { range = true })

Utils.User('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = 'Disable autoformat-on-save', bang = true })

Utils.User('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })
