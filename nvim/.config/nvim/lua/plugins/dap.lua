return function()
    local f = require('functions')
    local map = f.map()

    MiniDeps.add({
        source = 'jay-babu/mason-nvim-dap.nvim',
        depends = {
            { source = 'williamboman/mason.nvim' },
            {
                source = 'mfussenegger/nvim-dap',
                depends = {
                    { source = 'rcarriga/nvim-dap-ui' },
                    { source = 'nvim-neotest/nvim-nio' },
                    { source = 'williamboman/mason.nvim' },
                    { source = 'leoluz/nvim-dap-go' },
                    { source = 'nvim-lua/plenary.nvim' },
                    { source = 'theHamsta/nvim-dap-virtual-text' },
                },
            },
        },
    })

    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })

    local dap = require('dap')
    local fzf = require('fzf-lua')
    local dapui = require('dapui')
    local mason_dap = require('mason-nvim-dap')
    local vscode = require('dap.ext.vscode')
    local json = require('plenary.json')

    mason_dap.setup()

    dapui.setup()

    map.ln('du', dapui.toggle, 'toggle dapui')
    map.ln('dc', dap.continue, 'start/continue')
    map.ln('db', dap.toggle_breakpoint, 'toggle breakpoint')
    map.ln('dB', function() dap.set_breakpoint(vim.fn.input('Condition: ')) end, 'conditional breakpoint')
    map.ln('dd', fzf.dap_commands, 'commands')
    map.ln('do', fzf.dap_configurations, 'configs')
    map.ln('dl', fzf.dap_breakpoints, 'breakpoints')
    map.ln('di', fzf.dap_variables, 'variables')
    map.ln('df', fzf.dap_frames, 'frames')
    map.ln('de', function()
        require('dapui').eval()
        require('dapui').eval()
    end, 'eval')

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
    if vim.fn.filereadable('.vscode/launch.json') then vscode.load_launchjs() end

    -- go
    require('dap-go').setup({
        delve = {
            detached = vim.fn.has('win32') == 0,
        },
    })

    -- js/ts
    local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

    vscode.type_to_filetypes['node'] = js_filetypes
    vscode.type_to_filetypes['pwa-node'] = js_filetypes

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
