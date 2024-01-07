local M = {}

function M.on_lsp_attach(client, bufnr)
    local function set(lhs, rhs, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    local function handle_method(method, fn)
        if client.supports_method(method) then
            fn()
        end
    end

    local formatting = vim.lsp.protocol.Methods.textDocument_formatting
    handle_method(formatting, function()
        vim.lsp.handlers[formatting] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
        set("<leader><space>", vim.lsp.buf.format, "Format")
    end)

    local hover = vim.lsp.protocol.Methods.textDocument_hover
    handle_method(hover, function()
        vim.lsp.handlers[hover] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
        set("<leader>k", vim.lsp.buf.hover, "Hover")
    end)

    local signature_help = vim.lsp.protocol.Methods.textDocument_signatureHelp
    handle_method(signature_help, function()
        vim.lsp.handlers[signature_help] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
        set("<c-k>", vim.lsp.buf.signature_help, "Signature help", "i")
    end)

    local rename = vim.lsp.protocol.Methods.textDocument_rename
    handle_method(rename, function()
        set("<leader>cr", vim.lsp.buf.rename, "Rename")
    end)

    local diagnostics = vim.lsp.protocol.Methods.workspace_diagnostic
    handle_method(diagnostics, function()
        set("<leader>cd", vim.diagnostic.open_float, "Line diagnostics")

        set("<leader>sd", "<cmd>FzfLua lsp_document_diagnostics<cr>", "Document diagnostics")
        set("<leader>sD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", "Workspace diagnostics")
    end)

    local code_actions = vim.lsp.protocol.Methods.textDocument_codeAction
    handle_method(code_actions, function()
        set("<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", "Code actions", { "n", "v" })
    end)

    local definitions = vim.lsp.protocol.Methods.textDocument_definition
    handle_method(definitions, function()
        -- stylua: ignore
        set("gd", function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end, "Go to definition")
    end)

    local declarations = vim.lsp.protocol.Methods.textDocument_declaration
    handle_method(declarations, function()
        set("gD", "<cmd>FzfLua lsp_declarations<cr>", "Go to declarations")
    end)

    local typedefs = vim.lsp.protocol.Methods.textDocument_typeDefinition
    handle_method(typedefs, function()
        set("gy", "<cmd>FzfLua lsp_typedefs<cr>", "Go to type definition")
    end)

    local references = vim.lsp.protocol.Methods.textDocument_references
    handle_method(references, function()
        -- stylua: ignore
        set("gr", function() require("fzf-lua").lsp_references({ jump_to_single_result = true }) end, "Go to references")
    end)

    local implementations = vim.lsp.protocol.Methods.textDocument_implementation
    handle_method(implementations, function()
        set("gi", "<cmd>FzfLua lsp_implementations<cr>", "Go to implementations")
    end)

    local symbols = vim.lsp.protocol.Methods.textDocument_documentSymbol
    handle_method(symbols, function()
        set("<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", "Document symbols")
        -- stylua: ignore
        set("<leader>sS", function() require("fzf-lua").lsp_live_workspace_symbols({ no_header_i = true }) end, "Workspace symbols")
    end)

    local inlay_hints = vim.lsp.protocol.Methods.textDocument_inlayHint
    handle_method(inlay_hints, function()
        if vim.fn.has("nvim-0.10") then
            vim.lsp.inlay_hint.enable(bufnr, true)
        end
    end)
end

return M
