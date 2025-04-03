vim.api.nvim_create_user_command('Grep', function(params)
    if #params.args == 0 then
        print('Error: No arguments provided for Grep')
        return
    end

    vim.cmd('silent grep! ' .. vim.fn.shellescape(params.args))
    vim.cmd('copen')
end, {
    nargs = '*',
    complete = 'file',
})

vim.api.nvim_create_user_command('Make', function(params)
    local args = vim.fn.shellescape(params.args)

    -- The '!' prevents jumping to the first error automatically
    -- Output from make will be captured in the quickfix list
    vim.cmd('make! ' .. args)

    -- Open the quickfix window to display results (errors/warnings)
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd('copen')
    else
        vim.api.nvim_echo({ { 'Make completed successfully', 'Normal' } }, false, {})
    end
end, {
    nargs = '*',
    complete = 'file',
})

Fd = function(file_pattern, _)
    if file_pattern:sub(1, 1) == '*' then file_pattern = file_pattern:gsub('.', '.*%0') .. '.*' end
    local cmd = 'fd --color=never --full-path --type file --hidden --exclude=".git" "' .. file_pattern .. '"'
    local result = vim.fn.systemlist(cmd)
    return result
end

vim.opt.findfunc = 'v:lua.Fd'
