local add = MiniDeps.add

local mason_hooks = {
  post_checkout = function() vim.cmd('MasonUpdate') end,
}

add({
  source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
  depends = {
    {
      source = 'williamboman/mason.nvim',
      hooks = mason_hooks,
    },
  },
})

add('williamboman/mason-lspconfig.nvim')
add('neovim/nvim-lspconfig')

local mason = require('mason')
mason.setup()

local mti = require('mason-tool-installer')

local tools = require('tools')
local fmt = tools.formatters or {}
local servers = tools.servers or {}
servers = vim.tbl_keys(servers)

mti.setup({
  ensure_installed = vim.list_extend(servers, fmt),
  start_delay = 1000,
})

local mlsp = require('mason-lspconfig')
local lsp = require('lspconfig')

local capabilities = require('lspcapabilities')

mlsp.setup({
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = capabilities
      lsp[server_name].setup(server)
    end,
  },
})
