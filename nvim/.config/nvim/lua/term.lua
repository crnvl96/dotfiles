vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  group = vim.api.nvim_create_augroup('crnvl96-termopts', {}),
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
  group = vim.api.nvim_create_augroup('crnvl96-term-autoinsertmode', {}),
  callback = function() vim.cmd.startinsert() end,
})

local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
  vim.keymap.set('t', '<C-' .. key .. '>', function()
    local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
    vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
  end, { noremap = true })
end
