local add = MiniDeps.add

add({
  source = 'williamboman/mason.nvim',
  hooks = {
    post_checkout = function() vim.cmd('MasonUpdate') end,
  },
})

add('jay-babu/mason-nvim-dap.nvim')
add({
  source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
  depends = {
    'mfussenegger/nvim-dap',
  },
})
add('williamboman/mason-lspconfig.nvim')
add('neovim/nvim-lspconfig')

local servers = vim.tbl_keys(require('tools').servers) or {}
local fmt = require('tools').formatters or {}
local dbg = require('tools').debuggers or {}
local ensure_installed = vim.list_extend(servers, fmt)
ensure_installed = vim.list_extend(ensure_installed, dbg)

require('mason').setup()
require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
require('mason-nvim-dap').setup()

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
