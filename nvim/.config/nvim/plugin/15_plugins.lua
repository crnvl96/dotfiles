vim.cmd([[colorscheme ham]])

require('mini.extra').setup()
require('mason').setup()
require('mini.icons').setup()

Later(function()
    local mr = require('mason-registry')

    local ensure_installed = {
        'lua-language-server',
        'ruff',
        'basedpyright',
        'biome',
        'eslint-lsp',
        'vtsls',
        'prettierd',
        'stylua',
        'yamlfmt',
        'taplo',
        'tree-sitter-cli',
        'ast-grep',
    }

    mr.refresh(function()
        for _, tool in ipairs(ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then p:install() end
        end
    end)
end)

require('snacks').setup({
    input = { enabled = true },
    terminal = {
        enabled = true,
        win = {
            style = 'terminal',
            position = 'right',
            width = 0.5,
        },
    },
    bigfile = {
        size = 1 * 1024 * 1024,
        line_length = 300,
        notify = true,
    },
    image = {
        wo = {
            wrap = false,
            number = false,
            relativenumber = false,
            cursorcolumn = false,
            signcolumn = 'no',
            foldcolumn = '0',
            list = false,
            spell = false,
            statuscolumn = '',
        },
    },
    gitbrowse = {
        notify = true,
        open = function(url) vim.fn.setreg('+', url) end,
    },
    picker = {
        matcher = {
            cwd_bonus = true,
            frecency = true,
            history_bonus = true,
        },
        formatters = {
            file = {
                filename_first = false,
                truncate = 120,
            },
        },
        win = {
            preview = {
                keys = {
                    ['<a-w>'] = 'cycle_win',
                },
            },
            input = {
                keys = {
                    ['<a-h>'] = false,
                    ['<a-H>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
                    ['<a-y>'] = { 'copy', mode = { 'i', 'n' } },
                },
            },
            list = {
                keys = {
                    ['<a-h>'] = false,
                    ['<a-H>'] = 'toggle_hidden',
                    ['<a-y>'] = 'copy',
                },
            },
        },
        layouts = {
            ivy = {
                layout = {
                    box = 'vertical',
                    backdrop = false,
                    row = -1,
                    width = 0,
                    height = 0.5,
                    border = 'top',
                    title = ' {title} {live} {flags}',
                    title_pos = 'left',
                    { win = 'input', height = 1, border = 'bottom' },
                    {
                        box = 'horizontal',
                        { win = 'list', border = 'none' },
                        { win = 'preview', title = '{preview}', width = 0.618, border = 'left' },
                    },
                },
            },
            default = {
                preview = true,
                layout = {
                    box = 'horizontal',
                    width = 0.8,
                    min_width = 150,
                    height = 0.8,
                    {
                        box = 'vertical',
                        border = 'rounded',
                        title = '{title} {live} {flags}',
                        { win = 'input', height = 1, border = 'bottom' },
                        { win = 'list', border = 'none' },
                    },
                    { win = 'preview', title = '{preview}', border = 'rounded', width = 0.5 },
                },
            },
            vertical = {
                preview = true,
                layout = {
                    backdrop = false,
                    width = 0.5,
                    min_width = 80,
                    height = 0.8,
                    min_height = 30,
                    box = 'vertical',
                    border = 'rounded',
                    title = '{title} {live} {flags}',
                    title_pos = 'center',
                    { win = 'input', height = 1, border = 'bottom' },
                    { win = 'list', border = 'bottom' },
                    { win = 'preview', title = '{preview}', height = 0.4, border = 'none' },
                },
            },
        },
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
        g = require('mini.extra').gen_ai_spec.buffer(),
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

require('mini.indentscope').setup({
    options = {
        border = 'both',
        indent_at_cursor = true,
        n_lines = 10000,
        try_as_border = true,
    },
})

require('mini.diff').setup({ view = { style = 'sign' } })

require('flit').setup({ labeled_modes = 'nx' })

require('leap').opts.preview_filter = function(ch0, ch1, ch2)
    return not (ch1:match('%s') or ch0:match('%w') and ch1:match('%w') and ch2:match('%w'))
end

require('mini.snippets').setup({
    snippets = {
        require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        require('mini.snippets').gen_loader.from_lang(),
    },
    mappings = {
        expand = '<C-o>',
    },
})

require('neogen').setup({
    snippet_engine = 'mini',
    languages = {
        lua = { template = { annotation_convention = 'emmylua' } },
        python = { template = { annotation_convention = 'google_docstrings' } },
    },
})

require('grug-far').setup({
    headerMaxWidth = 80,
    windowCreationCommand = 'vsplit',
    maxLineLength = -1,
    transient = true,
    wrap = false,
})

require('conform').setup({
    notify_on_error = true,
    formatters = { injected = { ignore_errors = true } },
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

require('oil').setup({
    delete_to_trash = true,
    watch_for_changes = true,
    use_default_keymaps = false,
    keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-w>v'] = { 'actions.select', opts = { vertical = true } },
        ['<C-w>s'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-w>t'] = { 'actions.select', opts = { tab = true } },
        ['<C-w>p'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-w>r'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['g_'] = { 'actions.open_cwd', mode = 'n' },
        ['g-'] = { 'actions.cd', mode = 'n' },
        ['g,'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        ['gd'] = {
            desc = 'Toggle file detail view',
            callback = function()
                vim.g.oil_show_file_detail = not vim.g.oil_show_file_detail
                if vim.g.oil_show_file_detail then
                    require('oil').set_columns({ 'icon', 'permissions', 'size', 'mtime' })
                else
                    require('oil').set_columns({ 'icon' })
                end
            end,
        },
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
        chat = {
            adapter = vim.g.codecompanion_adapter,
            keymaps = {
                completion = {
                    modes = {
                        i = '<C-n>',
                    },
                },
            },
        },
        inline = { adapter = vim.g.codecompanion_adapter },
        cmd = { adapter = vim.g.codecompanion_adapter },
    },
    adapters = {
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = Utils.LoadKey('huggingface') },
            schema = {
                model = {
                    default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
                },
            },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = Utils.LoadKey('anthropic') },
            schema = {
                model = {
                    default = 'claude-3-7-sonnet-20250219',
                },
            },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = Utils.LoadKey('deepseek') },
            schema = {
                model = {
                    default = 'deepseek-chat',
                },
            },
        }),
    },
})

require('which-key').setup({
    preset = 'helix',
    delay = function(ctx) return ctx.plugin and 0 or 200 end,
    triggers = {
        { '<auto>', mode = 'nxso' },
    },
    win = {
        border = 'none',
        padding = { 1, 2 },
        title = false,
    },
    icons = { mappings = false },
    show_help = false,
    show_keys = false,
})

require('quicker').setup({
    keys = {
        {
            '>',
            function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
            desc = 'Expand quickfix context',
        },
        {
            '<',
            function() require('quicker').collapse() end,
            desc = 'Collapse quickfix context',
        },
    },
})

require('blink.compat').setup()
require('blink.cmp').setup({
    enabled = function() return vim.bo.buftype ~= 'prompt' end,
    snippets = { preset = 'mini_snippets' },
    signature = {
        enabled = true,
        window = {
            show_documentation = true,
        },
    },
    keymap = {
        preset = 'default',
        ['<C-k>'] = {},
        ['<C-i>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    cmdline = {
        completion = {
            menu = {
                auto_show = true,
            },
        },
    },
})

local capabilities = require('blink.cmp').get_lsp_capabilities()
for server, config in pairs({
    vtsls = {
        root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'package.json' }) end,
        single_file_support = false,
    },
    eslint = {
        root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { '.eslintrc.js' }) end,
        settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = 'auto' },
            format = false,
        },
    },
    biome = {
        root_dir = function(_, buffer) return buffer and vim.fs.root(buffer, { 'biome.json', 'biome.jsonc' }) end,
    },
    ruff = {
        on_init = function(client) client.server_capabilities.hoverProvider = false end,
        init_options = {
            settings = {
                lineLength = 88,
                logLevel = 'debug',
            },
        },
    },
    basedpyright = {
        settings = {
            basedpyright = {
                disableOrganizeImports = true,
                analysis = {
                    autoImportCompletions = true,
                    diagnosticMode = 'openFilesOnly',
                },
            },
        },
    },
    lua_ls = {
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
    config.capabilities = capabilities
    require('lspconfig')[server].setup(config)
end
