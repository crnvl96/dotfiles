if vim.fn.has('nvim-0.11') == 1 then
    vim.opt.completeopt:append('fuzzy')
    vim.opt.wildoptions:append('fuzzy')
end
