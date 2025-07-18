MiniDeps.now(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  local parsers = {
    'c',
    'lua',
    'prisma',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
    'javascript',
    'typescript',
    'tsx',
    'jsx',
    'python',
    'rust',
  }

  require('nvim-treesitter').install(parsers)

  local group = vim.api.nvim_create_augroup('crnvl96-treesitter', {})
  local pattern = vim.tbl_deep_extend('force', parsers, { 'codecompanion', 'javascriptreact', 'typescriptreact' })
  local callback = function() vim.treesitter.start() end

  vim.api.nvim_create_autocmd('FileType', { group = group, pattern = pattern, callback = callback })
end)
