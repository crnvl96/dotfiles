local hooks = Utils.MiniDepsHooks()

--- Use binaries installed with asdf to feed nvim lsps and formatters
--- When necessary, use local bin directory for the same purpose
local asdf = vim.env.HOME .. '/.asdf/shims/'
local lbin = vim.env.HOME .. '/.local/bin/'

--- These plugins don't require the `setup` call to work
MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add('andymass/vim-matchup')
MiniDeps.add('tpope/vim-fugitive')
MiniDeps.add('tpope/vim-sleuth')
MiniDeps.add('tpope/vim-eunuch')
MiniDeps.add('tpope/vim-rhubarb')

MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', hooks = hooks.treesitter })
MiniDeps.add('nvim-treesitter/nvim-treesitter-textobjects')
MiniDeps.add('MagicDuck/grug-far.nvim')
MiniDeps.add('danymat/neogen')
MiniDeps.add('kdheepak/lazygit.nvim')
MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = hooks.blink })

--- LSP/Formatting features
MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add('neovim/nvim-lspconfig')

--- Some plugins to provide AI integration
MiniDeps.add({ source = 'olimorris/codecompanion.nvim', depends = { 'j-hui/fidget.nvim' } })
MiniDeps.add('GeorgesAlkhouri/nvim-aider')

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

vim.g.codecompanion_adapter = 'deepseek'

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
                file = { opts = { provider = 'snacks' } },
                buffer = { opts = { provider = 'snacks' } },
                help = { opts = { provider = 'snacks' } },
                symbols = { opts = { provider = 'snacks' } },
            },
        },
    },
    adapters = {
        huggingface = require('codecompanion.adapters').extend('huggingface', {
            env = { api_key = Utils.ReadFromFile('huggingface') },
            schema = {
                model = {
                    default = 'deepseek-ai/DeepSeek-R1-Distill-Qwen-32B',
                },
            },
        }),
        anthropic = require('codecompanion.adapters').extend('anthropic', {
            env = { api_key = Utils.ReadFromFile('anthropic') },
            schema = {
                model = {
                    default = 'claude-3-7-sonnet-20250219',
                },
            },
        }),
        deepseek = require('codecompanion.adapters').extend('deepseek', {
            env = { api_key = Utils.ReadFromFile('deepseek') },
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

--- AI integration (requires aider.chat)
require('nvim_aider').setup()

require('grug-far').setup()

require('neogen').setup({
    snippet_engine = 'mini',
    languages = {
        lua = { template = { annotation_convention = 'emmylua' } },
        python = { template = { annotation_convention = 'google_docstrings' } },
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
    -- config.capabilities = require('blink.cmp').get_lsp_capabilities()
    require('lspconfig')[server].setup(config)
end

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.disable_autoformat = false

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
