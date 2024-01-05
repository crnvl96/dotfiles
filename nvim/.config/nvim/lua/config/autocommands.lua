vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("crnvl96_goto_last_buf_location", { clear = true }),
    callback = function()
        local exclude = { "gitcommit" }
        local buf = vim.api.nvim_get_current_buf()
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
            return
        end
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("crnvl96_highlight_on_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("crnvl96_set_node_path", { clear = true }),
    pattern = { "javascript, typescript, javascriptreact, typescriptreact" },
    callback = function()
        vim.g.node_host_prog = "/home/crnvl96/.asdf/shims/node"
        local home_dir = "/home/crnvl96"
        local node_bin = "/.asdf/installs/nodejs/20.8.1/bin"
        vim.g.node_host_prog = home_dir .. node_bin .. "/node"
        vim.cmd("let $PATH = '" .. home_dir .. node_bin .. ":' . $PATH")
    end,
})
