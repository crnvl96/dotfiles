local fmt = require('utils.fmt')
local n = require('utils.notification')

vim.g.autoformat = true
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
  notify_on_error = true,
  formatters = {
    injected = {
      ignore_errors = true,
    },
  },
  formatters_by_ft = {
    ['_'] = { 'trim_whitespace', 'trim_newlines' },
    json = { 'jq' },
    jsonc = { 'jq' },
    lua = { 'stylua' },
    markdown = { 'injected' },
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
    rust = { 'rustfmt' },
    css = fmt.get_web_fmt,
    javascript = fmt.get_web_fmt,
    javascriptreact = fmt.get_web_fmt,
    typescript = fmt.get_web_fmt,
    typescriptreact = fmt.get_web_fmt,
    toml = function() return fmt.evaluate_fmt({ 'pyproject.toml' }, { 'pyproject-fmt' }, { 'taplo' }) end,
  },
  format_on_save = function() return vim.g.autoformat and { timeout_ms = 3000, lsp_format = 'fallback' } end,
})

vim.api.nvim_create_user_command('ToggleFormat', function()
  vim.g.autoformat = not vim.g.autoformat
  n.publish(string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'))
end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })
