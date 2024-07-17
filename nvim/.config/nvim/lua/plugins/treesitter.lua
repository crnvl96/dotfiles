MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'gitcommit',
    'javascript',
    'json',
    'json5',
    'jsonc',
    'lua',
    'go',
    'gomod',
    'gosum',
    'gowork',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'regex',
    'rust',
    'sql',
    'toml',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
  },
  sync_install = false,
  auto_install = true,
  indent = { enable = true },
  highlight = {
    enable = true,
    disable = function(_, buf)
      -- Don't disable for read-only buffers.
      if not vim.bo[buf].modifiable then return false end

      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      -- Disable for files larger than 250 KB.
      return ok and stats and stats.size > (250 * 1024)
    end,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<cr>',
      node_incremental = '<cr>',
      scope_incremental = false,
      node_decremental = '-',
    },
  },
})
