local add = MiniDeps.add

add({
  source = 'stevearc/conform.nvim',
  depends = {
    'williamboman/mason.nvim',
  },
})

local function first(buf, ...)
  local conform = require('conform')

  for i = 1, select('#', ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, buf).available then return formatter end
  end

  return select(1, ...)
end

require('conform').setup({
  notify_on_error = false,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    ['javascript.jsx'] = { 'prettierd', 'prettier', stop_after_first = true },
    ['typescript.tsx'] = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    json5 = { 'prettierd', 'prettier', stop_after_first = true },
    go = { 'gofumpt', 'goimports', 'golines' },
    markdown = function(buf) return { first(buf, 'prettierd', 'prettier'), 'injected' } end,
  },
  formatters = {
    injected = {
      options = {
        ignore_errors = true,
      },
    },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = 'fallback',
  },
})
