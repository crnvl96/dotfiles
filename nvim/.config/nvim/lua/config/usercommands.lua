vim.api.nvim_create_user_command("Messages", function()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(bufnr, function()
        vim.cmd([[put=execute('messages')]])
    end)
    ---@diagnostic disable-next-line: deprecated
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.cmd.split()
    local winnr = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(winnr, bufnr)
end, { desc = "Render last messages in a scratch buffer", nargs = 0 })

vim.api.nvim_create_user_command("MarksDeleteAll", function()
    vim.cmd("delm! | delm A-Z0-9")

    local args = {}
    args.buf = vim.api.nvim_get_current_buf()

    require("utils.marks_handler").BufWinEnterHandler(args)
end, { desc = "Render last messages in a scratch buffer", nargs = 0 })
