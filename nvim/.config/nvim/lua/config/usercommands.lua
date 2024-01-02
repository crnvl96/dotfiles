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

vim.api.nvim_create_user_command("BufferOnly", function()
    vim.cmd("%bd|edit#|bd#")
end, { desc = "Close all other buffers", nargs = 0 })


vim.api.nvim_create_user_command("Grep", function(search_args)
    local cmdline = { "rg", "--vimgrep", "--smart-case", search_args.args }
    local rg_result = vim.fn.system(cmdline)

    if vim.v.shell_error == 1 and rg_result == "" then
        vim.notify("No matches found", vim.log.levels.WARN)
        return
    end

    if vim.v.shell_error ~= 0 then
        error("Command failed with error code: " .. vim.v.shell_error .. "\n" .. rg_result)
    end

    local lines = vim.fn.map(vim.split(rg_result, "\n", { trimempty = true }), function(_, item)
        local next = string.gmatch(item, "([^:]+):(%d+):(%d+):(.*)")
        local filename, line, col, text = next()
        return {
            filename = filename,
            lnum = line,
            col = col,
            vcol = 1,
            text = text,
        }
    end)

    vim.fn.setqflist({}, "r", {
        id = vim.fn.getqflist({ id = 0 }).id,
        items = lines,
        title = table.concat(cmdline, " "),
    })

    vim.cmd("copen")
end, {
    desc = "Recursively search for a pattern within the files in the current directory",
    nargs = 1,
})
