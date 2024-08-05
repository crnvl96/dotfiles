local function au(events, group, callback)
  return vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup('crnvl96' .. group, {}),
    callback = callback,
  })
end

local function highlight_on_yank() vim.highlight.on_yank() end

local function format_opts() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end

local function auto_resize_vim()
  vim.cmd('tabdo wincmd =')
  vim.cmd('tabnext ' .. vim.fn.tabpagenr())
end

au('TextYankPost', 'highlight_on_yank', highlight_on_yank)
au('FileType', 'format_opts', format_opts)
au('VimResized', 'auto_resize_vim', auto_resize_vim)
