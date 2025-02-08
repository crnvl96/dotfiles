local buf = vim.api.nvim_get_current_buf()

vim.lsp.start({
    name = 'iwes',
    cmd = { 'iwes' },
    root_dir = vim.fs.root(buf, { '.iwe' }),
    flags = {
        debounce_text_changes = 500,
    },
})
