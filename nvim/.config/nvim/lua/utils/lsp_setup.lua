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

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end
        on_lsp_attach(client, args.buf)
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

local register_capability = vim.lsp.handlers["client/registerCapability"]
vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
    local ret = register_capability(err, res, ctx)
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local bufnr = vim.api.nvim_get_current_buf()
    on_lsp_attach(client, bufnr)
    return ret
end
