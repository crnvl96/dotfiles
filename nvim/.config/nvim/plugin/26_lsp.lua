Add({ source = 'neovim/nvim-lspconfig' })

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
