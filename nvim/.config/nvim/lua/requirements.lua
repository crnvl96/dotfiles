MiniDeps.add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })
MiniDeps.add('WhoIsSethDaniel/mason-tool-installer.nvim')

require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
require('mini.extra').setup()
require('mini.visits').setup()
require('mason').setup()

require('mini.misc').setup_auto_root()

require('mason-tool-installer').setup({
  ensure_installed = {
    'shfmt',
    'stylua',
    'prettier',
    'prettierd',
    'staticcheck',
    'gofumpt',
    'goimports',
    'golines',
    'jq',
    'lua-language-server',
    'eslint-lsp',
    'vtsls',
    'gopls',
  },
})
