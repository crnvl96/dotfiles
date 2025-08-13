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

local set = vim.keymap.set

local function term_send(key)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)
      .. vim.api.nvim_replace_termcodes(key, true, true, true),
    't',
    true
  )
end

set('t', '<C-h>', function() term_send('<C-h>') end, { noremap = true })
set('t', '<C-j>', function() term_send('<C-j>') end, { noremap = true })
set('t', '<C-k>', function() term_send('<C-k>') end, { noremap = true })
set('t', '<C-l>', function() term_send('<C-l>') end, { noremap = true })
