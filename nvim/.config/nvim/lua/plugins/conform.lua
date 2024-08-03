MiniDeps.add('stevearc/conform.nvim')

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local first = function(bufnr, ...)
  local conform = require('conform')
  for i = 1, select('#', ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then return formatter end
  end
  return select(1, ...)
end

local conform = require('conform')

local slow_format_filetypes = {}

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

conform.setup({
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
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end

    if slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    local function on_format(err)
      if err and err:match('timeout$') then slow_format_filetypes[vim.bo[bufnr].filetype] = true end
    end

    return { timeout_ms = 1000, lsp_format = 'fallback' }, on_format
  end,
  format_after_save = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then return end
    return { lsp_format = 'fallback' }
  end,
})
