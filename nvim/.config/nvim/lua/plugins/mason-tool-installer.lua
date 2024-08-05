local add = MiniDeps.add
local tools = require('tools')

add({
  source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
  depends = {
    { source = 'williamboman/mason.nvim' },
    { source = 'williamboman/mason-lspconfig.nvim' },
    { source = 'jay-babu/mason-nvim-dap.nvim' },
  },
})

local servers = vim.tbl_keys(tools.servers)
local formatters = tools.formatters
local debuggers = tools.debuggers

local ensure_installed = {}

vim.list_extend(ensure_installed, servers)
vim.list_extend(ensure_installed, formatters)
vim.list_extend(ensure_installed, debuggers)

local masontoolinstaller = require('mason-tool-installer')

masontoolinstaller.setup({ ensure_installed = ensure_installed, delay = 1000 })
