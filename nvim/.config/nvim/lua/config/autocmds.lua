local function au(events, group, callback)
  return vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup('crnvl96' .. group, {}),
    callback = callback,
  })
end

au('TextYankPost', 'highlight_on_yank', function() vim.highlight.on_yank() end)
au('FileType', 'format_opts', function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end)
au('VimResized', 'auto_resize', function()
  vim.cmd('tabdo wincmd =')
  vim.cmd('tabnext ' .. vim.fn.tabpagenr())
end)
