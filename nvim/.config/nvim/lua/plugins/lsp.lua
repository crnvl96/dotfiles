return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        cmd = "LspStart",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            {
                "pmizio/typescript-tools.nvim",
                dependencies = {
                    { "nvim-lua/plenary.nvim" },
                },
            },
            {
                "ray-x/go.nvim",
                build = ':lua require("go.install").update_all_sync()',
                ft = { "go", "gomod" },
                dependencies = {
                    { "ray-x/guihua.lua" },
                    { "neovim/nvim-lspconfig" },
                },
            },
            {
                "folke/neodev.nvim",
            },
            {
                "williamboman/mason-lspconfig.nvim",
                dependencies = {
                    {
                        "williamboman/mason.nvim",
                        build = ":MasonUpdate",
                    },
                },
            },
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
                "ocamlformat",
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
            local lspconfig = require("lspconfig")
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
                    "ocamllsp",
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
                        require("go").setup()
                        lspconfig.gopls.setup({
                            capabilities = capabilities,
                            on_init = function(client)
                                if client.name == "gopls" then
                                    vim.keymap.set(
                                        "n",
                                        "<leader>td",
                                        "<cmd>lua require('dap-go').debug_test()<cr>",
                                        { silent = true, desc = "Debug nearest (Go)" }
                                    )

                                    vim.keymap.set("n", "<leader>tb", "<cmd>GoTestFunc<cr>", { silent = true, desc = "Bench nearest (Go)" })

                                    if not client.server_capabilities.semanticTokensProvider then
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
                                end
                            end,
                            settings = {
                                gopls = {
                                    gofumpt = true,
                                    codelenses = {
                                        gc_details = true,
                                        generate = true,
                                        regenerate_cgo = true,
                                        run_govulncheck = true,
                                        test = true,
                                        tidy = true,
                                        upgrade_dependency = true,
                                        vendor = true,
                                    },
                                    hints = {
                                        assignVariableTypes = false,
                                        compositeLiteralFields = false,
                                        compositeLiteralTypes = false,
                                        constantValues = false,
                                        functionTypeParameters = false,
                                        parameterNames = false,
                                        rangeVariableTypes = false,
                                    },
                                    analyses = {
                                        fieldalignment = true,
                                        nilness = true,
                                        unusedparams = true,
                                        unusedwrite = true,
                                        useany = true,
                                    },
                                    usePlaceholders = true,
                                    completeUnimported = true,
                                    staticcheck = true,
                                    directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
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
                    ocamllsp = function()
                        lspconfig.ocamllsp.setup({
                            capabilities = capabilities,
                            settings = {
                                codelens = { enable = true },
                            },
                            get_language_id = function(_, ftype)
                                return ftype
                            end,
                        })
                    end,
                },
            })

            vim.diagnostic.config({
                title = false,
                underline = true,
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    source = "always",
                    style = "minimal",
                    border = "rounded",
                    header = "",
                    prefix = "",
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
