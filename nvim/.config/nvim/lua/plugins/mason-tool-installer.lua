MiniDeps.add({
  source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
  hooks = {
    post_checkout = function() vim.cmd('MasonToolsInstall') end,
  },
  depends = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
})

local servers = vim.tbl_keys(require('tools').servers) or {}
local fmt = require('tools').formatters or {}
local dbg = require('tools').debuggers or {}
local ensure_installed = vim.list_extend(servers, fmt)
ensure_installed = vim.list_extend(ensure_installed, dbg)

require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
