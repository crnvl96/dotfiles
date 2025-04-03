local add = MiniDeps.add

add('nvim-lua/plenary.nvim')
add({ source = 'nvim-treesitter/nvim-treesitter', hooks = MiniDepsHooks.treesitter })
add('tpope/vim-fugitive')
add('tpope/vim-rhubarb')
add('tpope/vim-sleuth')
add('mbbill/undotree')
add('ibhagwan/fzf-lua')
add('lewis6991/gitsigns.nvim')
add('stevearc/conform.nvim')
add('stevearc/oil.nvim')
add('lervag/vimtex')
add({ source = 'Saghen/blink.cmp', hooks = MiniDepsHooks.blink })
add('olimorris/codecompanion.nvim')
add({ source = 'ravitemer/mcphub.nvim', hooks = MiniDepsHooks.mcphub })

require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = false },
    sync_install = false,
    auto_install = true,
    ignore_install = { 'latex' }, -- Due to vimtex
    ensure_installed = {
        'c',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'lua',
        'javascript',
        'typescript',
        'tsx',
        'python',
        'sql',
        'csv',
        'html',
        'css',
        'norg',
        'scss',
        'vue',
        'yaml',
    },
})

require('blink.cmp').setup()

require('oil').setup()

require('mcphub').setup({
    port = 9876,
    config = vim.fn.expand('~/.config/nvim/.mcpservers.json'),
})

require('codecompanion').setup({
    display = {
        chat = {
            show_settings = true,
            window = {
                layout = 'buffer', -- can also be `buffer|horizontal|vertical|float`
            },
        },
        diff = { -- To be used with the `@editor` tool
            enabled = true,
            close_chat_at = 360,
            opts = {
                'filler',
                'internal',
                'closeoff',
                'algorithm:histogram',
                'context:5',
                'linematch:60',
            },
        },
    },
    strategies = {
        inline = { adapter = Adapter },
        cmd = { adapter = Adapter },
        chat = {
            adapter = Adapter,
            tools = {
                mcp = {
                    callback = function() return require('mcphub.extensions.codecompanion') end,
                    description = 'Call tools and resources from the MCP Servers',
                    opts = { requires_approval = true },
                },
            },
            slash_commands = {
                file = { opts = { provider = 'fzf_lua' } },
                buffer = { opts = { provider = 'fzf_lua' } },
                help = { opts = { provider = 'fzf_lua' } },
                symbols = { opts = { provider = 'fzf_lua' } },
            },
            keymaps = {
                completion = {
                    modes = {
                        i = '<C-n>',
                    },
                },
            },
        },
    },
    adapters = {
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = ReadFromFile('.anthropic-api-key') },
            schema = { model = { default = 'claude-3-7-sonnet-20250219' } },
        }),
        gemini = require('codecompanion.adapters').extend('gemini', {
            env = { api_key = ReadFromFile('.gemini-api-key') },
            schema = { model = { default = 'gemini-2.5-pro-exp-03-25' } },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = ReadFromFile('.deepseek-api-key') },
            schema = { model = { default = 'deepseek-chat' } },
        }),
    },
})

-- Add a hint in the statusline to indicate that codecompanion is running

vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionRequestStarted',
    group = vim.api.nvim_create_augroup('crnvl96-codecompanion-statusline-start', {}),
    callback = function(e)
        CodecompanionStatus.active_requests[e.data.id] = {
            adapter = e.data.adapter.formatted_name,
            model = e.data.adapter.model,
            strategy = e.data.strategy,
        }

        CodecompanionStatus.count = CodecompanionStatus.count + 1

        vim.cmd('redrawstatus')
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionRequestFinished',
    group = vim.api.nvim_create_augroup('crnvl96-codecompanion-statusline-finish', {}),
    callback = function(e)
        if CodecompanionStatus.active_requests[e.data.id] then
            CodecompanionStatus.active_requests[e.data.id] = nil
            CodecompanionStatus.count = CodecompanionStatus.count - 1

            vim.cmd('redrawstatus')
        end
    end,
})

require('conform').setup({
    notify_on_error = true,
    formatters = {
        injected = { ignore_errors = true },
        stylua = { command = ASDFRust .. 'stylua' },
        prettierd = { command = ASDFNode .. 'prettierd' },
        biome = { command = ASDFNode .. 'biome' },
        yamlfmt = { command = ASDFGo .. 'yamlfmt' },
        ruff = { command = LBin .. 'ruff' },
        taplo = { command = ASDFRust .. 'taplo' },
    },
    formatters_by_ft = {
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
        lua = { 'stylua' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        yaml = { 'yamlfmt' },
        yml = { 'yamlfmt' },
        toml = { 'taplo' },
        markdown = { 'prettierd', 'injected' },
        python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
        typescript = function(bufnr)
            if bufnr and vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' }) then
                return { 'biome', 'biome-check', 'biome-organize-imports' }
            else
                return { 'prettierd' }
            end
        end,
        javascript = function(bufnr)
            if bufnr and vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' }) then
                return { 'biome', 'biome-check', 'biome-organize-imports' }
            else
                return { 'prettierd' }
            end
        end,
    },
    format_on_save = function(bufnr)
        if vim.g.fmtoff or vim.b[bufnr].fmtoff then return end
        return { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
})

require('fzf-lua').setup({
    fzf_opts = { ['--cycle'] = '' },
    keymap = {
        fzf = {
            ['ctrl-q'] = 'select-all+accept',
            ['ctrl-r'] = 'toggle+down',
            ['ctrl-e'] = 'toggle+up',
            ['ctrl-a'] = 'select-all',
            ['ctrl-o'] = 'toggle-all',
            ['ctrl-u'] = 'half-page-up',
            ['ctrl-d'] = 'half-page-down',
            ['ctrl-x'] = 'jump',
            ['ctrl-f'] = 'preview-page-down',
            ['ctrl-b'] = 'preview-page-up',
        },
        builtin = {
            ['<c-f>'] = 'preview-page-down',
            ['<c-b>'] = 'preview-page-up',
        },
    },
})

require('gitsigns').setup({
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end)
    end,
})

---
--- Plugin related specs that goes outside the config
---

vim.g.vimtex_view_method = 'zathura'

local fzf_lua_ui = require('fzf-lua.providers.ui_select')

vim.ui.select = function(items, opts, on_choice)
    if not fzf_lua_ui.is_registered() then fzf_lua_ui.register() end
    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
end

vim.keymap.set({ 'n', 'x' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle AI chat' })
vim.keymap.set('x', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to AI chat' })
vim.keymap.set('v', 'ghy', ':GBrowse!<CR>', { desc = 'Copy link' })
vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end, { desc = 'Find files (FZF)' })
vim.keymap.set('n', '<Leader>/', function() require('fzf-lua').live_grep() end, { desc = 'Grep files (FZF)' })
vim.keymap.set('x', '<Leader>/', function() require('fzf-lua').grep_visual() end, { desc = 'Grep visual (FZF)' })
vim.keymap.set('n', '-', function() require('oil').open() end, { desc = 'Oil' })
vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end, { desc = 'Find buffers (FZF)' })
vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end, { desc = 'Resume last finder (FZF)' })
vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end, { desc = 'Quickfix (FZF)' })

vim.keymap.set('c', '<C-n>', function()
    if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 't', true)
    end
    return ''
end, { expr = true, noremap = false })

vim.keymap.set('c', '<C-p>', function()
    if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 't', true)
    end
    return ''
end, { expr = true, noremap = false })

vim.opt.statusline = table.concat({
    ' %f', -- File path
    ' %m%r%h%w', -- File flags (modified, readonly, etc.)
    ' %{%v:lua.StatuslineDiagnostics()%}', -- Diagnostics
    '%=', -- Right align the rest
    '%{%v:lua.CodeCompanionStatusline()%}', -- CodeCompanion status
    ' %y', -- File type
    ' %l:%c ', -- Line and column
    ' %p%% ', -- Percentage through file
}, '')
