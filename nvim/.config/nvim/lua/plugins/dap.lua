local add = MiniDeps.add

add({
    source = 'mfussenegger/nvim-dap',
    depends = {
        'rcarriga/nvim-dap-ui',
        'nvim-neotest/nvim-nio',
        'williamboman/mason.nvim',
        'leoluz/nvim-dap-go',
        'nvim-lua/plenary.nvim',
    },
})

add({
    source = 'jay-babu/mason-nvim-dap.nvim',
    depends = {
        'mfussenegger/nvim-dap',
        'williamboman/mason.nvim',
    },
})

require('mason-nvim-dap').setup()

local dap = require('dap')
local dapui = require('dapui')
local vscode = require('dap.ext.vscode')
local json = require('plenary.json')
local set = vim.keymap.set
local hl = vim.api.nvim_set_hl

local function toggle_cond_breakpoint() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end

hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

dapui.setup()

-- stylua: ignore start
set('n', '<leader>dc', dap.continue,           { desc = 'Debug: Start/Continue' })
set('n', '<leader>di', dap.step_into,          { desc = 'Debug: Step Into' })
set('n', '<leader>dO', dap.step_over,          { desc = 'Debug: Step Over' })
set('n', '<leader>do', dap.step_out,           { desc = 'Debug: Step Out' })
set('n', '<leader>db', dap.toggle_breakpoint,  { desc = 'Debug: Toggle Breakpoint' })
set('n', '<leader>dB', toggle_cond_breakpoint, { desc = 'Debug: Set Breakpoint' })
set('n', '<leader>du', dapui.toggle,           { desc = 'Debug: See last session result.' })

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config']     = dapui.close
-- stylua: ignore end

-- Setup dap config by VsCode launch.json file
vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
-- Extends dap.configurations with entries read from .vscode/launch.json
if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

require('dap-go').setup({
    delve = {
        detached = vim.fn.has('win32') == 0,
    },
})

if not dap.adapters['pwa-node'] then
    require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
            command = 'node',
            args = {
                vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
                '${port}',
            },
        },
    }
end

if not dap.adapters['node'] then
    dap.adapters['node'] = function(cb, config)
        if config.type == 'node' then config.type = 'pwa-node' end
        local nativeAdapter = dap.adapters['pwa-node']
        if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
        else
            cb(nativeAdapter)
        end
    end
end

local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

vscode.type_to_filetypes['node'] = js_filetypes
vscode.type_to_filetypes['pwa-node'] = js_filetypes

for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
        dap.configurations[language] = {
            {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
            },
            {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach to running process',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                protocol = 'inspector',
                skipFiles = {
                    '<node_internals>/**',
                    'node_modules/**',
                },
                resolveSourceMapLocations = {
                    '${workspaceFolder}/**',
                    '!**/node_modules/**',
                },
            },
            {
                name = '-----------------',
            },
        }
    end
end
