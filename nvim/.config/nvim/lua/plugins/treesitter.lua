local add = MiniDeps.add

add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = { post_update = function() vim.cmd('TSUpdate') end },
})

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'bash' },
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
