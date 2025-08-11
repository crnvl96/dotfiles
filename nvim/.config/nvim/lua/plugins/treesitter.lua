MiniDeps.now(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  -- MiniDeps.add('nvim-treesitter/nvim-treesitter-textobjects')

  require('nvim-treesitter').install({
    'c',
    'lua',
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
    'bash',
    'gitcommit',
    'html',
    'hyprlang',
    'json',
    'json5',
    'jsonc',
    'rasi',
    'regex',
    'scss',
    'toml',
    'vim',
    'yaml',
  })
end)
