return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        cmd = "LspStart",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            { "williamboman/mason.nvim", build = ":MasonUpdate" },
            { "williamboman/mason-lspconfig.nvim" },
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

            local show_handler = vim.diagnostic.handlers.virtual_text.show
            local hide_handler = vim.diagnostic.handlers.virtual_text.hide

            vim.diagnostic.handlers.virtual_text = {
                show = function(ns, bufnr, diagnostics, options)
                    table.sort(diagnostics, function(diag1, diag2)
                        return diag1.severity > diag2.severity
                    end)
                    return show_handler(ns, bufnr, diagnostics, options)
                end,
                hide = hide_handler,
            }

            vim.diagnostic.config({
                virtual_text = {
                    prefix = "",
                    format = function(diagnostic)
                        return vim.split(diagnostic.message, "\n")[1]
                    end,
                },
                float = {
                    source = "always",
                    style = "minimal",
                    header = "",
                    prefix = "",
                    border = "rounded",
                },
                signs = false,
            })

            require("lspconfig.ui.windows").default_options.border = "rounded"

            local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
                workspace = {
                    -- PERF: didChangeWatchedFiles is too slow.
                    -- TODO: Remove this when https://github.com/neovim/neovim/issues/23291#issuecomment-1686709265 is fixed.
                    didChangeWatchedFiles = { dynamicRegistration = false },
                },
            })

            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = { "n:i", "v:s" },
                desc = "Disable diagnostics in insert and select mode",
                callback = function(e)
                    vim.diagnostic.disable(e.buf)
                end,
            })

            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = "i:n",
                desc = "Enable diagnostics when leaving insert mode",
                callback = function(e)
                    vim.diagnostic.enable(e.buf)
                end,
            })

            vim.api.nvim_create_autocmd("ColorScheme", {
                desc = "Clear LSP highlight groups",
                callback = function()
                    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
                        vim.api.nvim_set_hl(0, group, {})
                    end
                end,
            })

            local function on_lsp_attach(client, bufnr)
                local function set(lhs, rhs, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                local function handle_method(method, fn)
                    if client.supports_method(method) then
                        fn()
                    end
                end

                -- workaround for gopls not supporting semanticTokensProvider
                -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
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

                -- local inlay_hint = vim.lsp.protocol.Methods.textDocument_inlayHint
                -- handle_method(inlay_hint, function()
                --     vim.lsp.inlay_hint(bufnr, true)
                -- end)

                -- local completion = vim.lsp.protocol.Methods.textDocument_completion
                -- handle_method(completion, function()
                --     local function tab_complete()
                --         if vim.fn.pumvisible() == 1 then
                --             return "<Down>"
                --         end
                --         local c = vim.fn.col(".") - 1
                --         ---@diagnostic disable-next-line: param-type-mismatch
                --         local is_whitespace = c == 0 or vim.fn.getline("."):sub(c, c):match("%s")
                --         if is_whitespace then
                --             return "<Tab>"
                --         end
                --         local lsp_completion = vim.bo.omnifunc == "v:lua.vim.lsp.omnifunc"
                --         if lsp_completion then
                --             return "<C-x><C-o>"
                --         end
                --         return "<C-x><C-n>"
                --     end
                --
                --     local function tab_prev()
                --         if vim.fn.pumvisible() == 1 then
                --             return "<Up>"
                --         end
                --         return "<Tab>"
                --     end
                --
                --     vim.keymap.set("i", "<C-Space>", tab_complete, { expr = true })
                --     vim.keymap.set("i", "<C-n>", tab_complete, { expr = true })
                --     vim.keymap.set("i", "<C-p>", tab_prev, { expr = true })
                -- end)

                local hover = vim.lsp.protocol.Methods.textDocument_hover
                handle_method(hover, function()
                    vim.lsp.handlers[hover] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
                    set("<leader>k", vim.lsp.buf.hover, "Hover")
                end)

                local signature_help = vim.lsp.protocol.Methods.textDocument_signatureHelp
                handle_method(signature_help, function()
                    vim.lsp.handlers[signature_help] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
                    set("<C-k>", vim.lsp.buf.signature_help, "Signature help", "i")
                end)

                local rename = vim.lsp.protocol.Methods.textDocument_rename
                handle_method(rename, function()
                    set("<leader>cr", vim.lsp.buf.rename, "Rename")
                end)

                local diagnostics = vim.lsp.protocol.Methods.workspace_diagnostic
                handle_method(diagnostics, function()
                    set("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")

                    set("<leader>sd", function()
                        require("fzf-lua").lsp_document_diagnostics()
                    end, "Document diagnostics")

                    set("<leader>sD", function()
                        require("fzf-lua").lsp_workspace_diagnostics()
                    end, "All diagnostics")
                end)

                local code_actions = vim.lsp.protocol.Methods.textDocument_codeAction
                handle_method(code_actions, function()
                    set("<leader>ca", function()
                        require("fzf-lua").lsp_code_actions()
                    end, "Code actions", { "n", "v" })
                end)

                local definitions = vim.lsp.protocol.Methods.textDocument_definition
                handle_method(definitions, function()
                    set("gd", function()
                        require("fzf-lua").lsp_definitions({
                            jump_to_single_result = true,
                        })
                    end, "Go to definition")
                end)

                local declarations = vim.lsp.protocol.Methods.textDocument_declaration
                handle_method(declarations, function()
                    set("gD", function()
                        require("fzf-lua").lsp_declarations()
                    end, "Go to declarations")
                end)

                local typedefs = vim.lsp.protocol.Methods.textDocument_typeDefinition
                handle_method(typedefs, function()
                    set("gy", function()
                        require("fzf-lua").lsp_typedefs()
                    end, "Go to type definition")
                end)

                local references = vim.lsp.protocol.Methods.textDocument_references
                handle_method(references, function()
                    set("gr", function()
                        require("fzf-lua").lsp_references({
                            jump_to_single_result = true,
                        })
                    end, "Go to references")
                end)

                local implementations = vim.lsp.protocol.Methods.textDocument_implementation
                handle_method(implementations, function()
                    set("gi", function()
                        require("fzf-lua").lsp_implementations()
                    end, "Go to implementations")
                end)

                local symbols = vim.lsp.protocol.Methods.textDocument_documentSymbol
                handle_method(symbols, function()
                    set("<leader>ss", function()
                        require("fzf-lua").lsp_document_symbols()
                    end, "Document symbols")

                    set("<leader>sS", function()
                        require("fzf-lua").lsp_live_workspace_symbols({
                            no_header_i = true,
                        })
                    end, "Workspace symbols")
                end)

                local highlights = vim.lsp.protocol.Methods.textDocument_documentHighlight
                handle_method(highlights, function()
                    vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave", "BufEnter" }, {
                        group = vim.api.nvim_create_augroup("crnvl96_lsp_highlights", { clear = false }),
                        buffer = bufnr,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
                        group = vim.api.nvim_create_augroup("crnvl96_lsp_highlights", { clear = false }),
                        buffer = bufnr,
                        callback = vim.lsp.buf.clear_references,
                    })
                end)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then
                        return
                    end
                    on_lsp_attach(client, args.buf)
                end,
            })

            local register_capability = vim.lsp.handlers["client/registerCapability"]
            vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
                local ret = register_capability(err, res, ctx)
                local client_id = ctx.client_id
                local client = vim.lsp.get_client_by_id(client_id)
                local bufnr = vim.api.nvim_get_current_buf()
                on_lsp_attach(client, bufnr)
                return ret
            end

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
                            capabilities = capabilities,
                            settings = {
                                javascript = {
                                    inlayHints = {
                                        includeInlayEnumMemberValueHints = true,
                                        includeInlayFunctionLikeReturnTypeHints = true,
                                        includeInlayFunctionParameterTypeHints = true,
                                        includeInlayParameterNameHints = "all",
                                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                        includeInlayPropertyDeclarationTypeHints = true,
                                        includeInlayVariableTypeHints = true,
                                    },
                                },
                                typescript = {
                                    inlayHints = {
                                        includeInlayEnumMemberValueHints = true,
                                        includeInlayFunctionLikeReturnTypeHints = true,
                                        includeInlayFunctionParameterTypeHints = true,
                                        includeInlayParameterNameHints = "all",
                                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                                        includeInlayPropertyDeclarationTypeHints = true,
                                        includeInlayVariableTypeHints = true,
                                    },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
