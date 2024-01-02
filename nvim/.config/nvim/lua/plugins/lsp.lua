return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        cmd = "LspStart",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
            { "williamboman/mason.nvim", build = ":MasonUpdate" },
            { "williamboman/mason-lspconfig.nvim" },
            { "pmizio/typescript-tools.nvim" },
            { "dmmulroy/tsc.nvim" },
            { "onsails/lspkind.nvim" },
            {
                "hrsh7th/nvim-cmp",
                dependencies = {
                    { "hrsh7th/cmp-nvim-lsp" },
                    { "hrsh7th/cmp-buffer" },
                    { "L3MON4D3/LuaSnip" },
                    { "windwp/nvim-autopairs" },
                    { "hrsh7th/cmp-path" },
                    { "hrsh7th/cmp-nvim-lua" },
                    { "rcarriga/cmp-dap" },
                    { "hrsh7th/cmp-nvim-lsp-signature-help" },
                },
            },
        },
        config = function()
            local clue = require("mini.clue")
            clue.config.clues = vim.list_extend(clue.config.clues, {
                { mode = "n", keys = "<leader>c", desc = "+code" },
                { mode = "x", keys = "<leader>c", desc = "+code" },
            })

            require("mason").setup()

            local ensure_installed = {
                "stylua",
                "gofumpt",
                "goimports",
                "prettierd",

                "js-debug-adapter",
                "delve",
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
                signs = true,
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

                    -- set("<leader>sd", vim.diagnostic.setqflist, "Workspace diagnostics")

                    set("<leader>sd", function()
                        require("fzf-lua").lsp_document_diagnostics()
                    end, "Document diagnostics")

                    set("<leader>sD", function()
                        require("fzf-lua").lsp_workspace_diagnostics()
                    end, "All diagnostics")
                end)

                local code_actions = vim.lsp.protocol.Methods.textDocument_codeAction
                handle_method(code_actions, function()
                    -- set("<leader>ca", vim.lsp.buf.code_action, "Code actions", { "n", "v" })

                    set("<leader>ca", function()
                        require("fzf-lua").lsp_code_actions()
                    end, "Code actions", { "n", "v" })
                end)

                local definitions = vim.lsp.protocol.Methods.textDocument_definition
                handle_method(definitions, function()
                    -- set("gd", vim.lsp.buf.definition, "Go to definition")

                    set("gd", function()
                        require("fzf-lua").lsp_definitions({
                            jump_to_single_result = true,
                        })
                    end, "Go to definition")
                end)

                local declarations = vim.lsp.protocol.Methods.textDocument_declaration
                handle_method(declarations, function()
                    -- set("gD", vim.lsp.buf.declaration, "Go to declarations")

                    set("gD", function()
                        require("fzf-lua").lsp_declarations()
                    end, "Go to declarations")
                end)

                local typedefs = vim.lsp.protocol.Methods.textDocument_typeDefinition
                handle_method(typedefs, function()
                    -- set("gy", vim.lsp.buf.type_definition, "Go to type definition")

                    set("gy", function()
                        require("fzf-lua").lsp_typedefs()
                    end, "Go to type definition")
                end)

                local references = vim.lsp.protocol.Methods.textDocument_references
                handle_method(references, function()
                    -- set("gr", vim.lsp.buf.references, "Go to references")

                    set("gr", function()
                        require("fzf-lua").lsp_references({
                            jump_to_single_result = true,
                        })
                    end, "Go to references")
                end)

                local implementations = vim.lsp.protocol.Methods.textDocument_implementation
                handle_method(implementations, function()
                    -- set("gi", vim.lsp.buf.implementation, "Go to implementations")

                    set("gi", function()
                        require("fzf-lua").lsp_implementations()
                    end, "Go to implementations")
                end)

                local symbols = vim.lsp.protocol.Methods.textDocument_documentSymbol
                handle_method(symbols, function()
                    -- set("<leader>ss", vim.lsp.buf.document_symbol, "Document symbols")
                    -- set("<leader>sS", vim.lsp.buf.workspace_symbol, "Workspace symbols")

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
                        require("tsc").setup()
                        require("typescript-tools").setup({
                            capabilities = capabilities,
                            settings = {
                                tsserver_file_preferences = {
                                    includeInlayParameterNameHints = "literals",
                                    includeInlayVariableTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                },
                            },
                        })
                        return true
                    end,
                },
            })

            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            local luasnip = require("luasnip")

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            cmp.setup({
                enabled = function()
                    ---@diagnostic disable-next-line: deprecated
                    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
                end,
                preselect = cmp.PreselectMode.None,
                sorting = require("cmp.config.default")().sorting,
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "text_symbol",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        before = function(_, vim_item)
                            return vim_item
                        end,
                    }),
                },
                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },
                window = {
                    completion = {
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    },
                    documentation = {
                        border = "rounded",
                        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
                    },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Replace }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Replace }),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_active_entry() then
                                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                            else
                                fallback()
                            end
                        end,
                        s = cmp.mapping.confirm({ select = true }),
                        c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- that way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp_signature_help" },
                    { name = "nvim_lua" },
                    {
                        name = "nvim_lsp",
                        entry_filter = function(entry)
                            local kind = cmp.lsp.CompletionItemKind[entry:get_kind()]
                            if kind == "Text" then
                                return false
                            end
                            if kind == "Snippet" then
                                return false
                            end
                            return true
                        end,
                    },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
            })

            require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                sources = {
                    { name = "dap" },
                },
            })

            local npairs = require("nvim-autopairs")

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            npairs.setup({
                enable_check_bracket_line = false,
                ignored_next_char = "[%w%.]",
            })

            local Rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")

            local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

            npairs.add_rules({
                -- Rule for a pair with left-side ' ' and right side ' '
                Rule(" ", " ")
                    -- Pair will only occur if the conditional function returns true
                    :with_pair(function(opts)
                        -- We are checking if we are inserting a space in (), [], or {}
                        local pair = opts.line:sub(opts.col - 1, opts.col)
                        return vim.tbl_contains({
                            brackets[1][1] .. brackets[1][2],
                            brackets[2][1] .. brackets[2][2],
                            brackets[3][1] .. brackets[3][2],
                        }, pair)
                    end)
                    :with_move(cond.none())
                    :with_cr(cond.none())
                    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
                    :with_del(function(opts)
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        local context = opts.line:sub(col - 1, col + 2)
                        return vim.tbl_contains({
                            brackets[1][1] .. "  " .. brackets[1][2],
                            brackets[2][1] .. "  " .. brackets[2][2],
                            brackets[3][1] .. "  " .. brackets[3][2],
                        }, context)
                    end),
            })
            -- For each pair of brackets we will add another rule
            for _, bracket in pairs(brackets) do
                npairs.add_rules({
                    -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(cond.none())
                        :with_move(function(opts)
                            return opts.char == bracket[2]
                        end)
                        :with_del(cond.none())
                        :use_key(bracket[2])
                        -- Removes the trailing whitespace that can occur without this
                        :replace_map_cr(function(_)
                            return "<C-c>2xi<CR><C-c>O"
                        end),
                })
            end
        end,
    },
}
