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
