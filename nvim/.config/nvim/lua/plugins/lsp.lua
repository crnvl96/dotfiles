local add = MiniDeps.add

add({
  source = 'neovim/nvim-lspconfig',
  depends = {
    'williamboman/mason-lspconfig.nvim',
    'williamboman/mason.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
})

local capabilities = require('lspcapabilities')

require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      local server = require('tools').servers[server_name] or {}
      server.capabilities = capabilities
      require('lspconfig')[server_name].setup(server)
    end,
  },
})
