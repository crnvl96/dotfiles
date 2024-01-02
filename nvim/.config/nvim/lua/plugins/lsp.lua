return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        cmd = "LspStart",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            { "williamboman/mason.nvim", build = ":MasonUpdate" },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/cmp-nvim-lsp" },
        },
        config = function()
            require("mason").setup()

            local ensure_installed = {
                "stylua",
                "gofumpt",
                "goimports",
                "prettierd",
            }

            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)

            local function install()
                for _, tool in ipairs(ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end

            if mr.refresh then
                mr.refresh(install)
            else
                install()
            end

            vim.diagnostic.config({
                float = {
                    border = "rounded",
                },
            })

            require("lspconfig.ui.windows").default_options.border = "rounded"

            local capabilities =
                vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities(), {
                    workspace = {
                        -- PERF: didChangeWatchedFiles is too slow.
                        -- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
                        didChangeWatchedFiles = { dynamicRegistration = false },
                    },
                })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "tsserver",
                    "lua_ls",
                    "gopls",
                    "vimls",
                    "bashls",
                    "jsonls",
                    "eslint",
                },
                handlers = {
                    function(server)
                        require("lspconfig")[server].setup({ capabilities = capabilities })
                    end,
                    eslint = function()
                        require("lspconfig").eslint.setup({
                            capabilities = capabilities,
                            settings = {
                                workingDirectory = { mode = "auto" },
                                format = { enable = false },
                                lint = { enable = true },
                            },
                        })
                    end,
                    jsonls = function()
                        require("lspconfig").jsonls.setup({
                            capabilities = capabilities,
                            settings = {
                                json = {
                                    validate = { enable = true },
                                    format = { enable = true },
                                },
                            },
                        })
                    end,
                    lua_ls = function()
                        require("lspconfig").lua_ls.setup({
                            capabilities = capabilities,
                            on_init = function(client)
                                local path = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
                                if not path or not (vim.uv.fs_stat(path .. "/.luarc.lua") or vim.uv.fs_stat(path .. "/.luarc")) then
                                    client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                                        Lua = {
                                            runtime = {
                                                version = "LuaJIT",
                                            },
                                            workspace = {
                                                checkThirdParty = false,
                                                library = {
                                                    vim.env.VIMRUNTIME,
                                                    "${3rd}/luv/library",
                                                },
                                            },
                                        },
                                    })
                                    client.notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = client.config.settings })
                                end
                                return true
                            end,
                            settings = {
                                Lua = {
                                    telemetry = { enable = false },
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    format = { enable = false },
                                    hint = {
                                        enable = true,
                                        arrayIndex = "Disable",
                                    },
                                    completion = {
                                        callSnippet = "Disable",
                                        keywordSnippet = "Disable",
                                    },
                                },
                            },
                        })
                    end,
                    gopls = function()
                        require("lspconfig").gopls.setup({
                            capabilities = capabilities,
                            on_init = function(client)
                                if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
                                    local semanticTokens = client.config.capabilities.textDocument.semanticTokens
                                    client.server_capabilities.semanticTokensProvider = {
                                        full = true,
                                        legend = {
                                            tokenTypes = semanticTokens.tokenTypes,
                                            tokenModifiers = semanticTokens.tokenModifiers,
                                        },
                                        range = true,
                                    }
                                end
                            end,
                            settings = {
                                gopls = {
                                    gofumpt = true,
                                    codelenses = {
                                        gc_details = true,
                                        generate = true,
                                        run_govulncheck = true,
                                        test = true,
                                        tidy = true,
                                        upgrade_dependency = true,
                                    },
                                    hints = {
                                        assignVariableTypes = true,
                                        compositeLiteralFields = true,
                                        compositeLiteralTypes = true,
                                        constantValues = true,
                                        functionTypeParameters = true,
                                        parameterNames = true,
                                        rangeVariableTypes = true,
                                    },
                                    analyses = {
                                        nilness = true,
                                        unusedparams = true,
                                        unusedvariable = true,
                                        unusedwrite = true,
                                        useany = true,
                                    },
                                    staticcheck = true,
                                    directoryFilters = { "-.git", "-node_modules" },
                                    semanticTokens = true,
                                },
                            },
                            flags = {
                                debounce_text_changes = 150,
                            },
                        })
                    end,
                    tsserver = function()
                        require("lspconfig").tsserver.setup({
                            settings = {
                                completions = {
                                    completeFunctionCalls = false,
                                },
                            },
                        })
                        return true
                    end,
                },
            })
        end,
    },
}
