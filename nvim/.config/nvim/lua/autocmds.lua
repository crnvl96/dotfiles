vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-restore-cursor', {}),
  callback = function(e)
    pcall(
      vim.api.nvim_win_set_cursor,
      vim.fn.bufwinid(e.buf),
      vim.api.nvim_buf_get_mark(e.buf, [["]])
    )
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-yank-hl', { clear = true }),
  callback = function() vim.hl.on_yank({ higroup = 'Visual', priority = 250 }) end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-big-file', { clear = true }),
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(
      function() vim.bo[args.buf].syntax = vim.filetype.match({ buf = args.buf }) or '' end
    )
  end,
})
