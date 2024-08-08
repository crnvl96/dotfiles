local add = MiniDeps.add

local function l_map(lhs, rhs, opts, mode)
    opts = type(opts) == 'string' and { desc = opts } or opts
    mode = mode or 'n'

    return vim.keymap.set(mode, '<leader>' .. lhs, rhs, opts)
end

return function()
    add({
        source = 'mfussenegger/nvim-dap',
        depends = {
            { source = 'rcarriga/nvim-dap-ui' },
            { source = 'nvim-neotest/nvim-nio' },
            { source = 'williamboman/mason.nvim' },
            { source = 'leoluz/nvim-dap-go' },
            { source = 'nvim-lua/plenary.nvim' },
        },
    })

    add({
        source = 'jay-babu/mason-nvim-dap.nvim',
        depends = {
            { source = 'mfussenegger/nvim-dap' },
            { source = 'williamboman/mason.nvim' },
        },
    })

    local hl = vim.api.nvim_set_hl
    hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    require('mason-nvim-dap').setup()

    local dapui = require('dapui')
    dapui.setup()

    l_map('du', dapui.toggle, 'toggle dapui')

    local dap = require('dap')
    local fzf = require('fzf-lua')

    l_map('dc', dap.continue, 'start/continue')
    l_map('db', dap.toggle_breakpoint, 'toggle breakpoint')
    l_map('dB', function() dap.set_breakpoint(vim.fn.input('Condition: ')) end, 'conditional breakpoint')
    l_map('dd', fzf.dap_commands, 'commands')
    l_map('do', fzf.dap_configurations, 'configs')
    l_map('dl', fzf.dap_breakpoints, 'breakpoints')
    l_map('di', fzf.dap_variables, 'variables')
    l_map('df', fzf.dap_frames, 'frames')

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    local vscode = require('dap.ext.vscode')
    local json = require('plenary.json')

    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

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
end
