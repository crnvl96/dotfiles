vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-last-location', {}),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-yank-hl', {}),
  callback = function()
    vim.hl.on_yank({
      priority = 250,
      higroup = 'IncSearch',
      timeout = 150,
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-big-file', {}),
  pattern = 'bigfile', -- defined on filetype.lua
  callback = function(args)
    vim.schedule(function() vim.bo.syntax = vim.filetype.match({ buf = args.buf }) or '' end)
  end,
})
