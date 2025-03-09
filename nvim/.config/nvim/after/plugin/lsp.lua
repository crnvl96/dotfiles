--- Use binaries installed with asdf to feed nvim lsps and formatters
--- When necessary, use local bin directory for the same purpose
local asdf = vim.env.HOME .. '/.asdf/shims/'
local lbin = vim.env.HOME .. '/.local/bin/'

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
