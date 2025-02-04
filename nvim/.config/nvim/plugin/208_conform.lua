Add('stevearc/conform.nvim')

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  formatters = { injected = { ignore_errors = true } },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    lua = { 'stylua' },
    javascript = { 'prettierd' },
    css = { 'prettierd' },
    html = { 'prettierd' },
    scss = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    json = { 'prettierd' },
    jsonc = { 'prettierd' },
    yaml = { 'yamlfmt' },
    yml = { 'yamlfmt' },
    toml = { 'taplo' },
    markdown = { 'prettierd', 'injected' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
  },
  format_on_save = function()
    if not vim.g.autoformat then return end
    return {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback',
    }
  end,
})
