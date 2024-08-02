vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96/highlight_on_yank', {}),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('crnvl96/resize_splits', {}),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96/formatopts', {}),
  callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
})
