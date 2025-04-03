MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', hooks = MiniDepsHooks.treesitter })

MiniDeps.add('tpope/vim-fugitive')
MiniDeps.add('tpope/vim-rhubarb')

MiniDeps.add('ibhagwan/fzf-lua')
MiniDeps.add('lewis6991/gitsigns.nvim')

MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add('stevearc/oil.nvim')

-- Testing the buitin completion for a while
--
-- MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = MiniDepsHooks.blink })
-- require('blink.cmp').setup()

MiniDeps.add('olimorris/codecompanion.nvim')
MiniDeps.add({ source = 'ravitemer/mcphub.nvim', hooks = MiniDepsHooks.mcphub })

vim.ui.select = function(items, opts, on_choice)
    if not require('fzf-lua.providers.ui_select').is_registered() then
        require('fzf-lua.providers.ui_select').register()
    end
    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
end

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = { 'yaml' },
    },
    sync_install = false,
    auto_install = true,
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

require('oil').setup()

require('mcphub').setup({
    port = 9876,
    config = vim.fn.expand('~/.config/nvim/static/mcp/mcpservers.json'),
})

require('codecompanion').setup({
    display = {
        chat = {
            show_settings = true,
        },
        diff = {
            enabled = true,
            close_chat_at = 360,
            opts = { 'filler', 'internal', 'closeoff', 'algorithm:histogram', 'context:5', 'linematch:60' },
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
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = ReadFromFile('huggingface') },
            schema = { model = { default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B' } },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = ReadFromFile('anthropic') },
            schema = { model = { default = 'claude-3-7-sonnet-20250219' } },
        }),
        gemini = require('codecompanion.adapters').extend('gemini', {
            env = { api_key = ReadFromFile('gemini') },
            schema = { model = { default = 'gemini-2.5-pro-exp-03-25' } },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = ReadFromFile('deepseek') },
            schema = { model = { default = 'deepseek-chat' } },
        }),
    },
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
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
})

require('fzf-lua').setup({
    fzf_opts = {
        ['--cycle'] = '',
    },
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
