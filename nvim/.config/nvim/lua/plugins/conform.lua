MiniDeps.later(function()
  MiniDeps.add('stevearc/conform.nvim')

  local function get_root_dir(root_files, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
  end

  local function get_web_formatter(bufnr)
    if get_root_dir({ 'biome.json', 'biome.jsonc' }, bufnr) then
      return { 'biome', 'biome-check', 'biome-organize-imports' }
    else
      return { 'prettier' }
    end
  end

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.autoformat = true

  vim.api.nvim_create_user_command('ToggleFormat', function()
    vim.g.autoformat = not vim.g.autoformat
    vim.notify(string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
  end, { desc = 'Toggle conform.nvim auto-formatting', nargs = 0 })

  vim.keymap.set('n', '=', 'mzgggqG`z<cmd>delmarks z<cr>zz')

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
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      rust = { 'rustfmt' },
    },
    format_on_save = function() return vim.g.autoformat and { timeout_ms = 3000, lsp_format = 'fallback' } end,
  })
end)
