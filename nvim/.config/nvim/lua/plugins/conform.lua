MiniDeps.later(function()
  MiniDeps.add('stevearc/conform.nvim')

  local get_root = require('conform.util').root_file

  local function get_web_formatter()
    local root = get_root({ 'biome.json', 'biome.jsonc' })
    return root and { 'biome', 'biome-check', 'biome-organize-imports' } or { 'prettier' }
  end

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.autoformat = true

  require('conform').setup({
    notify_on_error = true,
    formatters = { injected = { ignore_errors = true } },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      json = { 'jq' },
      jsonc = { 'jq' },
      css = get_web_formatter,
      javascript = get_web_formatter,
      javascriptreact = get_web_formatter,
      typesCRipt = get_web_formatter,
      typescriptreact = get_web_formatter,
      lua = { 'stylua' },
      markdown = { 'injected' },
      toml = function()
        local root = get_root({ 'pyproject.toml' })
        return root and { 'pyproject-fmt' } or { 'taplo' }
      end,
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      rust = { 'rustfmt' },
    },
    format_on_save = function() return vim.g.autoformat and { timeout_ms = 3000, lsp_format = 'fallback' } end,
  })

  vim.api.nvim_create_user_command('ToggleFormat', function()
    vim.g.autoformat = not vim.g.autoformat
    vim.notify(string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
  end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })

  vim.keymap.set('n', '=', 'mzgggqG`z<cmd>delmarks z<cr>zz')
end)
