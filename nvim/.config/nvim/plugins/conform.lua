MiniDeps.later(function()
  MiniDeps.add('stevearc/conform.nvim')

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.conform = true

  local function get_root_dir(root_files, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
  end

  require('conform').setup({
    notify_on_error = true,
    formatters = {
      injected = {
        ignore_errors = true,
      },
    },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      css = { 'prettier' },
      javascript = function(bufnr)
        local biome_root_files = { 'biome.json', 'biome.jsonc' }

        if get_root_dir(biome_root_files, bufnr) then
          return { 'biome', 'biome-check', 'biome-organize-imports' }
        else
          return { 'prettier' }
        end
      end,
      javascriptreact = function(bufnr)
        local biome_root_files = { 'biome.json', 'biome.jsonc' }

        if get_root_dir(biome_root_files, bufnr) then
          return { 'biome', 'biome-check', 'biome-organize-imports' }
        else
          return { 'prettier' }
        end
      end,
      json = { 'prettier' },
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
    },
    format_on_save = function() return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' } end,
  })
end)
