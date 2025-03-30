MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', hooks = MiniDepsHooks.treesitter })

MiniDeps.add('tpope/vim-sleuth')
MiniDeps.add('tpope/vim-fugitive')
MiniDeps.add('tpope/vim-rhubarb')

MiniDeps.add('ibhagwan/fzf-lua')
MiniDeps.add('lewis6991/gitsigns.nvim')

MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add('stevearc/oil.nvim')

MiniDeps.add('olimorris/codecompanion.nvim')
MiniDeps.add({ source = 'ravitemer/mcphub.nvim', hooks = MiniDepsHooks.mcphub })

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
    },
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
        },
    },
    adapters = {
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = ReadFromFile('huggingface') },
            schema = { model = { default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B' } },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = ReadFromFile('anthropic') },
            schema = {
                model = {
                    choices = {
                        ['claude-3-7-sonnet-20250219'] = { opts = { can_reason = false } },
                        'claude-3-5-sonnet-20241022',
                        'claude-3-5-haiku-20241022',
                        'claude-3-opus-20240229',
                        'claude-2.1',
                    },
                    default = 'claude-3-7-sonnet-20250219',
                },
            },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = ReadFromFile('deepseek') },
            schema = { model = { default = 'deepseek-chat' } },
        }),
    },
})

require('mcphub').setup({
    port = 9876,
    config = vim.fn.expand('~/.config/nvim/static/mcp/mcpservers.json'),
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

local ui_select = require('fzf-lua.providers.ui_select')
local fzflua = require('fzf-lua')

vim.ui.select = function(items, opts, on_choice)
    if not ui_select.is_registered() then ui_select.register() end
    if #items > 0 then return vim.ui.select(items, opts, on_choice) end
end

fzflua.setup({
    winopts = {
        border = 'single',
        preview = {
            layout = 'flex',
            flip_columns = 120,
            vertical = 'up:70%',
            horizontal = 'right:65%',
            border = 'single',
        },
    },
    fzf_colors = {
        bg = { 'bg', 'Normal' },
        gutter = { 'bg', 'Normal' },
        info = { 'fg', 'Conditional' },
        scrollbar = { 'bg', 'Normal' },
        separator = { 'fg', 'Comment' },
    },
    fzf_opts = {
        ['--cycle'] = '',
        ['--info'] = 'default',
        ['--layout'] = 'reverse-list',
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
    signs = {
        add = { text = '┆' },
        change = { text = '┆' },
        delete = { text = '┆' },
        topdelete = { text = '┆' },
        changedelete = { text = '┆' },
        untracked = { text = '┆' },
    },
    signs_staged = {
        add = { text = '┆' },
        change = { text = '┆' },
        delete = { text = '┆' },
        topdelete = { text = '┆' },
        changedelete = { text = '┆' },
        untracked = { text = '┆' },
    },
    attach_to_untracked = true,
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

        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
        map('v', '<leader>hr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hi', gitsigns.preview_hunk_inline)
        map('n', '<leader>hb', function() gitsigns.blame_line({ full = true }) end)
        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
        map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>td', gitsigns.toggle_deleted)
        map('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
    end,
})

require('oil').setup({
    columns = { 'icon' },
    watch_for_changes = true,
    view_options = { show_hidden = true },
    use_default_keymaps = false,
    keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-w>v'] = { 'actions.select', opts = { vertical = true } },
        ['<C-w>s'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-w>t'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
})
