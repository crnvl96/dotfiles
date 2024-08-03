MiniDeps.add({
  source = 'mfussenegger/nvim-dap',
  depends = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'nvim-lua/plenary.nvim',
  },
})

local dap = require('dap')
local dapui = require('dapui')
local vscode = require('dap.ext.vscode')
local json = require('plenary.json')
local set = vim.keymap.set

local function conditionalbp() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end

vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

dapui.setup()

set('n', '<leader>dc', dap.continue, { desc = 'Debug: Start/Continue' })
set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
set('n', '<leader>dO', dap.step_over, { desc = 'Debug: Step Over' })
set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
set('n', '<leader>dB', conditionalbp, { desc = 'Debug: Set Breakpoint' })
set('n', '<leader>du', dapui.toggle, { desc = 'Debug: See last session result.' })

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

require('dap-go').setup({
  delve = {
    detached = vim.fn.has('win32') == 0,
  },
})

-- Setup dap config by VsCode launch.json file
vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

-- Extends dap.configurations with entries read from .vscode/launch.json
if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end
