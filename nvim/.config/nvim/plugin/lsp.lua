vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("crnvl96_on_lsp_attach", { clear = true }),
    desc = "Setup lsp keymaps on attach event",
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end
        require("functions.lsp").on_lsp_attach(client, args.buf)
    end,
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
