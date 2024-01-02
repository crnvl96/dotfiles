vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("crnvl96_highlight_on_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
