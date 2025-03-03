local load_key = function(f)
    local path = vim.fn.stdpath('config') .. '/static/files/' .. f
    local file = io.open(path, 'r')
    if file then
        local key = file:read('*a'):gsub('%s+$', '')
        file:close()
        if not key then
            vim.notify('Missing file: ' .. f, 'ERROR')
            return nil
        end
        return key
    end
    return nil
end

Add('nvim-lua/plenary.nvim')
Add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })
Add('nvim-treesitter/nvim-treesitter-textobjects')
Add('tpope/vim-fugitive')
Add('tpope/vim-sleuth')
Add('tpope/vim-eunuch')
Add('stevearc/conform.nvim')
Add('stevearc/quicker.nvim')
Add('Saghen/blink.cmp')
Add('olimorris/codecompanion.nvim')
Add('neovim/nvim-lspconfig')
Add('kevinhwang91/nvim-bqf')

require('mini.extra').setup()
require('mini.diff').setup()
require('mini.misc').setup_auto_root()
require('bqf').setup()
require('quicker').setup()
require('mini.align').setup({ mappings = { start = '' } })
require('mini.splitjoin').setup({ mappings = { toggle = 'S' } })
require('mini.pick').setup({ source = { show = require('mini.pick').default_show } })

require('mini.operators').setup({
    evaluate = { prefix = 'g=' },
    replace = { prefix = 's' },
    exchange = { prefix = '' },
    multiply = { prefix = '' },
    sort = { prefix = '' },
})

require('mini.files').setup({
    content = { prefix = function() end },
    windows = { preview = true },
    mappings = {
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
    },
})

require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = true, disable = { 'yaml' } },
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

require('mini.ai').setup({
    n_lines = 500,
    custom_textobjects = {
        o = require('mini.ai').gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        a = require('mini.ai').gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        G = require('mini.extra').gen_ai_spec.buffer(),
        d = require('mini.extra').gen_ai_spec.diagnostic(),
        i = require('mini.extra').gen_ai_spec.indent(),
        n = require('mini.extra').gen_ai_spec.number(),
        e = { -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
        },
        u = require('mini.ai').gen_spec.function_call(), -- u for "Usage"
        U = require('mini.ai').gen_spec.function_call({ name_pattern = '[%w_]' }), -- without dot in function nam
    },
    silent = true,
    search_method = 'cover',
    mappings = {
        around_next = '',
        inside_next = '',
        around_last = '',
        inside_last = '',
    },
})

require('codecompanion').setup({
    display = {
        chat = {
            window = {
                layout = 'vertical',
            },
        },
    },
    strategies = {
        inline = { adapter = vim.g.codecompanion_adapter },
        cmd = { adapter = vim.g.codecompanion_adapter },
        chat = {
            adapter = vim.g.codecompanion_adapter,
            keymaps = {
                completion = {
                    modes = {
                        i = '<C-Space>',
                    },
                },
            },
            slash_commands = {
                file = { opts = { provider = 'mini_pick' } },
                buffer = { opts = { provider = 'mini_pick' } },
                help = { opts = { provider = 'mini_pick' } },
                symbols = { opts = { provider = 'mini_pick' } },
            },
        },
    },
    adapters = {
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = load_key('huggingface') },
            schema = {
                model = {
                    default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
                },
            },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = load_key('anthropic') },
            schema = {
                model = {
                    default = 'claude-3-7-sonnet-20250219',
                },
            },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = load_key('deepseek') },
            schema = {
                model = {
                    default = 'deepseek-chat',
                },
            },
        }),
    },
})

require('blink.cmp').setup({
    enabled = function() return vim.bo.buftype ~= 'prompt' end,
    fuzzy = { implementation = 'lua' },
    completion = {
        menu = { border = 'single' },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = 'single' },
        },
    },
    signature = {
        enabled = true,
        window = { show_documentation = true, border = 'single' },
    },
    keymap = {
        preset = 'default',
        ['<C-k>'] = {},
        ['<C-i>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
})
