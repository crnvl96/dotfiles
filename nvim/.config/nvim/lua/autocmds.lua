vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-last-location', { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then vim.cmd('normal! g`"zz') end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-yank-hl', { clear = true }),
  callback = function()
    vim.hl.on_yank({
      priority = 250,
      higroup = 'IncSearch',
      timeout = 250,
    })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-big-file', { clear = true }),
  pattern = 'bigfile', -- defined on filetype.lua
  callback = function(args)
    vim.schedule(function() vim.bo.syntax = vim.filetype.match({ buf = args.buf }) or '' end)
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = vim.api.nvim_create_augroup('crnvl96-show-cursorline', { clear = true }),
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = false
    end
  end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = vim.api.nvim_create_augroup('crnvl96-hide-cursorline', { clear = true }),
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
  desc = 'https://www.reddit.com/r/neovim/comments/1ehidxy/you_can_remove_padding_around_neovim_instance/',
  group = vim.api.nvim_create_augroup('crnvl96-term-colorscheme', { clear = true }),
  callback = function()
    if vim.api.nvim_get_hl(0, { name = 'Normal' }).bg then
      io.write(string.format('\027]11;#%06x\027\\', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg))
    end
    vim.api.nvim_create_autocmd('UILeave', {
      callback = function() io.write('\027]111\027\\') end,
    })
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  group = vim.api.nvim_create_augroup('crnvl96-termopts', { clear = true }),
  callback = function()
    if vim.opt.buftype:get() == 'terminal' then
      local set = vim.opt_local
      set.number = false
      set.relativenumber = false
      set.scrolloff = 0 -- Don't scroll when at the top or bottom of the terminal buffer
      vim.opt.filetype = 'terminal'

      vim.cmd.startinsert()
    end

    local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)

    for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
      vim.keymap.set('t', '<C-' .. key .. '>', function()
        local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
        vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
      end, { noremap = true })
    end

    vim.keymap.set('t', '<C-b><C-b>', function() vim.api.nvim_feedkeys(code_term_esc, 't', true) end)
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  group = vim.api.nvim_create_augroup('crnvl96-autoinsertmode', { clear = true }),
  callback = function()
    if vim.opt.buftype:get() == 'terminal' then vim.cmd.startinsert() end
  end,
})
