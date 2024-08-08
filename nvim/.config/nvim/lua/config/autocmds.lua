local function au(events, group, callback, pattern)
    return vim.api.nvim_create_autocmd(events, {
        pattern = pattern or '*',
        group = vim.api.nvim_create_augroup('crnvl96' .. group, {}),
        callback = callback,
    })
end

return function()
    au('TextYankPost', 'highlight_on_yank', function() vim.highlight.on_yank() end)

    au('FileType', 'format_opts', function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end)

    au('FileType', 'format_opts', function() vim.cmd('setlocal shiftwidth=4 tabstop=4') end, 'go')

    au('VimResized', 'auto_resize_vim', function()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. vim.fn.tabpagenr())
    end)
end
