return function()
    local f = require('functions')
    local au, g = f.au, f.g

    au('TextYankPost', g('highlight_on_yank', true), function()
        local on_yank = vim.highlight.on_yank
        on_yank()
    end)

    au('FileType', g('format_opts', true), function()
        local cmd = vim.cmd
        cmd('setlocal formatoptions-=c formatoptions-=o')
    end)

    au('VimResized', g('auto_resize_vim', true), function()
        vim.cmd('tabdo wincmd =')
        vim.cmd('tabnext ' .. vim.fn.tabpagenr())
    end)
end
