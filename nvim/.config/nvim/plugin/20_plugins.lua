local add = MiniDeps.add
local hooks = Utils.MiniDepsHooks()

local asdf = vim.env.HOME .. '/.asdf/shims/'
local lbin = vim.env.HOME .. '/.local/bin/'

add({ name = 'mini.nvim' })
add('nvim-lua/plenary.nvim')
add('MagicDuck/grug-far.nvim')
add({ source = 'nvim-treesitter/nvim-treesitter', hooks = hooks.treesitter })
add({ source = 'Saghen/blink.cmp', hooks = hooks.blink })
add('nvim-treesitter/nvim-treesitter-textobjects')
add('tpope/vim-fugitive')
add('tpope/vim-sleuth')
add('tpope/vim-eunuch')
add('tpope/vim-rhubarb')
add('stevearc/conform.nvim')
add('neovim/nvim-lspconfig')
add('danymat/neogen')

require('mini.icons').setup()
require('mini.extra').setup()

require('mini.pairs').setup()
require('mini.move').setup()
require('mini.snippets').setup()
require('mini.indentscope').setup()
require('mini.align').setup({ mappings = { start = '' } })
require('mini.splitjoin').setup({ mappings = { toggle = 'S' } })
require('mini.pick').setup({ window = { prompt_cursor = '▇ ', prompt_prefix = ' ' } })

require('mini.jump2d').setup({
    spotter = require('mini.jump2d').gen_pattern_spotter('[^%s%p]+'),
    view = { dim = true, n_steps_ahead = 2 },
})

require('mini.operators').setup({
    evaluate = { prefix = 'g=' },
    replace = { prefix = 's' },
    exchange = { prefix = '' },
    multiply = { prefix = '' },
    sort = { prefix = '' },
})

require('mini.files').setup({
    windows = {
        preview = true,
        width_preview = 80,
    },
    mappings = {
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
    },
})

require('mini.surround').setup({
    mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = '',
        find_left = '',
        highlight = '',
        replace = 'gsr',
        update_n_lines = '',

        suffix_last = '',
        suffix_next = '',
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
        e = {
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
        },
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

require('mini.clue').setup({
    clues = {
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows({ submode_resize = true }),
        require('mini.clue').gen_clues.z(),
    },
    triggers = {
        { mode = 'n', keys = '<Leader>' }, -- Leader triggers
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = '<Localleader>' }, -- Leader triggers
        { mode = 'x', keys = '<Localleader>' },
        { mode = 'n', keys = [[\]] }, -- mini.basics
        { mode = 'n', keys = '[' }, -- mini.bracketed
        { mode = 'n', keys = ']' },
        { mode = 'x', keys = '[' },
        { mode = 'x', keys = ']' },
        { mode = 'i', keys = '<C-x>' }, -- Built-in completion
        { mode = 'n', keys = 'g' }, -- `g` key
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = "'" }, -- Marks
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' }, -- Registers
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' }, -- Window commands
        { mode = 'n', keys = 'z' }, -- `z` key
        { mode = 'x', keys = 'z' },
    },
    window = { config = { width = 'auto' }, delay = 200 },
})

require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = {
            'yaml',
        },
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

require('blink.cmp').setup({
    enabled = function() return vim.bo.buftype ~= 'prompt' end,
    completion = {
        menu = { border = 'single' },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = 'single' },
        },
    },
    cmdline = {
        keymap = {
            ['<Tab>'] = { 'accept' },
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        completion = {
            menu = { auto_show = true },
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

for server, config in pairs({
    vtsls = {
        cmd = { asdf .. 'vtsls', '--stdio' },
        root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
        single_file_support = false,
    },
    eslint = {
        cmd = {
            asdf .. 'vscode-eslint-language-server',
            '--stdio',
        },

        root_dir = function(_, buffer)
            local file_patterns = {
                '.eslintrc.js',
                'eslint.config.mjs',
            }

            return buffer and vim.fs.root(buffer, file_patterns)
        end,
        settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = {
                mode = 'auto',
            },

            format = false,
        },
    },
    biome = {
        cmd = { asdf .. 'biome', 'lsp-proxy' },
        root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'biome.json', 'biome.jsonc' }) end,
    },
    ruff = {
        cmd = { lbin .. 'ruff', 'server' },
        on_init = function(client) client.server_capabilities.hoverProvider = false end,
        init_options = {
            settings = {
                lineLength = 88,
                logLevel = 'debug',
            },
        },
    },
    basedpyright = {
        cmd = { lbin .. 'basedpyright-langserver', '--stdio' },
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
                analysis = { autoImportCompletions = true, diagnosticMode = 'openFilesOnly' },
            },
        },
    },
    lua_ls = {
        cmd = { asdf .. 'lua-language-server' },
        on_init = function(client)
            client.server_capabilities.semanticTokensProvider = nil

            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath('config')
                    and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc'))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT',
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        '$VIMRUNTIME',
                        '$XDG_DATA_HOME/nvim/site/pack/deps/opt',
                        '${3rd}/luv/library',
                    },
                },
            })
        end,
    },
}) do
    config = config or {}
    config.capabilities = require('blink.cmp').get_lsp_capabilities()
    require('lspconfig')[server].setup(config)
end

require('conform').setup({
    notify_on_error = true,
    formatters = {
        injected = { ignore_errors = true },
        stylua = { command = asdf .. 'stylua' },
        prettierd = { command = asdf .. 'prettierd' },
        biome = { command = asdf .. 'biome' },
        yamlfmt = { command = asdf .. 'yamlfmt' },
        ruff = { command = lbin .. 'ruff' },
        taplo = { command = asdf .. 'taplo' },
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
        markdown = { 'injected' },
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

require('grug-far').setup()

require('neogen').setup({
    snippet_engine = 'mini',
    languages = {
        lua = { template = { annotation_convention = 'emmylua' } },
        python = { template = { annotation_convention = 'google_docstrings' } },
    },
})
