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
  end,
})

vim.api.nvim_create_autocmd('TermEnter', {
  group = vim.api.nvim_create_augroup('crnvl96-autoinsertmode', { clear = true }),
  callback = function() vim.cmd.startinsert() end,
})

vim.api.nvim_create_autocmd('TabEnter', {
  group = vim.api.nvim_create_augroup('crnvl96-autoinsertmode', { clear = true }),
  callback = function(e)
    if vim.bo[e.buf].filetype == 'terminal' then vim.cmd.startinsert() end
  end,
})

local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
  vim.keymap.set('t', '<C-' .. key .. '>', function()
    local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
    vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
  end, { noremap = true })
end

local set = vim.keymap.set

set('t', '<C-e><C-e>', function() vim.api.nvim_feedkeys(code_term_esc, 't', true) end)

set('t', '<C-b>', function()
  vim.api.nvim_feedkeys(code_term_esc, 't', true)
  require('fzf-lua').buffers()
end)
