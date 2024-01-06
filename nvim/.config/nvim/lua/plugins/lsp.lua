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
            { "pmizio/typescript-tools.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
            { "folke/neodev.nvim" },
        },
        config = function()
            require("neodev").setup({
                library = {
                    enabled = true,
                    runtime = true,
                    types = true,
                    plugins = true,
                },
                setup_jsonls = true,
                lspconfig = true,
                pathStrict = true,
            })

            require("mason").setup()

            local tools = {
                "stylua",
                "gofumpt",
                "goimports",
                "gomodifytags",
                "impl",
                "prettierd",
            }

            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
            local function ensure_installed()
                for _, tool in ipairs(tools) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end

            require("lspconfig.ui.windows").default_options.border = "rounded"

            local capabilities =
                vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities(), {
                    workspace = {
                        -- PERF: didChangeWatchedFiles is too slow.
                        -- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
                        didChangeWatchedFiles = { dynamicRegistration = false },
                    },
                })

            local lspconfig = require("lspconfig")
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
                        lspconfig[server].setup({ capabilities = capabilities })
                    end,
                    eslint = function()
                        lspconfig.eslint.setup({
                            capabilities = capabilities,
                            settings = {
                                workingDirectory = { mode = "auto" },
                                format = { enable = false },
                                lint = { enable = true },
                            },
                        })
                    end,
                    jsonls = function()
                        lspconfig.jsonls.setup({
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
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            -- on_init = function(client)
                            --     local path = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
                            --     if not path or not (vim.uv.fs_stat(path .. "/.luarc.lua") or vim.uv.fs_stat(path .. "/.luarc")) then
                            --         client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
                            --             Lua = {
                            --                 runtime = {
                            --                     version = "LuaJIT",
                            --                 },
                            --                 workspace = {
                            --                     checkThirdParty = false,
                            --                     library = {
                            --                         vim.env.VIMRUNTIME,
                            --                         "${3rd}/luv/library",
                            --                     },
                            --                 },
                            --             },
                            --         })
                            --         client.notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = client.config.settings })
                            --     end
                            --     return true
                            -- end,
                            settings = {
                                Lua = {
                                    telemetry = { enable = false },
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    format = { enable = false },
                                    completion = {
                                        callSnippet = "Disable",
                                        keywordSnippet = "Disable",
                                    },
                                },
                            },
                        })
                    end,
                    gopls = function()
                        lspconfig.gopls.setup({
                            capabilities = capabilities,
                            on_init = function(client)
                                if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
                                    vim.keymap.set(
                                        "n",
                                        "<leader>td",
                                        "<cmd>lua require('dap-go').debug_test()<cr>",
                                        { silent = true, desc = "Debug Nearest (Go)" }
                                    )

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
                        require("typescript-tools").setup({
                            capabilities = capabilities,
                        })
                        return true
                    end,
                },
            })

            local register_capability = vim.lsp.handlers["client/registercapability"]
            vim.lsp.handlers["client/registercapability"] = function(err, res, ctx)
                local ret = register_capability(err, res, ctx)
                local client_id = ctx.client_id
                local cli = vim.lsp.get_client_by_id(client_id)
                local bufnr = vim.api.nvim_get_current_buf()
                require("functions.lsp").on_lsp_attach(cli, bufnr)
                return ret
            end
        end,
    },
}
