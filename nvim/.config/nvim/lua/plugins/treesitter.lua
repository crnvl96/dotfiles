local add = MiniDeps.add

add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = { post_update = function() vim.cmd('TSUpdate') end },
})

require('nvim-treesitter.configs').setup({
  -- stylua: ignore
  ensure_installed = {
    'bash',
    'c',
    'lua',
    'query',
    'vim', 'vimdoc',
    'markdown', 'markdown_inline',
    'typescript', 'javascript',
    'go', 'gomod', 'gosum', 'gowork', 'gotmpl'
  },
  sync_install = false,
  auto_install = true,
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'markdown' },
  },
})
