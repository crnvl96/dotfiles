local bind = require('utils.bind')

---@class Nvim.Keymaps
local M = {}

--- Simulates a key combo on terminal: first, <Esc> is pressed, and them the key sent as parameter
---@param key string Key to be executed on the terminal
---@return function
function M.term_send_esc(key)
  return function()
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)
        .. vim.api.nvim_replace_termcodes(key, true, true, true),
      't',
      true
    )
  end
end

--- Creates a Scratch transient buffer for general annotations
---@return nil
function M.create_scratch_buf()
  vim.cmd('bel 10new')
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs({
    filetype = 'scratch',
    buftype = 'nofile',
    bufhidden = 'wipe',
    swapfile = false,
    modifiable = true,
  }) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end

bind.map('Y', 'yg_', 'Yank till end of line', { 'n', 'x' })
bind.map('<Leader>p', '"+p', 'Paste from clipboard', { 'n', 'x', 'o' })
bind.map('<Leader>P', '"+P', 'Paste from clipboard before cursor', { 'n', 'x', 'o' })
bind.map('<Leader>y', '"+y', 'Yank to clipboard', { 'n', 'x', 'o' })
bind.map('<Leader>Y', '"+yg_', 'Yank to clipboard till end of line', { 'n', 'x', 'o' })
bind.map('<Esc>', '<Cmd>noh<CR><Esc>', 'Clear hls and <Esc>', { 'n', 'x', 'i', 's' })
bind.map('<C-S>', '<Esc><Cmd>silent! update | redraw<CR>', 'Save', { 'n', 'i', 'x' })
bind.map('j', "v:count == 0 ? 'gj' : 'j'", 'Go up one line', { 'n', 'x' }, { expr = true })
bind.map('k', "v:count == 0 ? 'gk' : 'k'", 'Go down one line', { 'n', 'x' }, { expr = true })
bind.xmap('p', 'P', 'Paste before cursor')
bind.xmap('<', '<gv', 'Deindent selection')
bind.xmap('>', '>gv', 'Indent selection')
bind.nmap('<C-h>', '<C-w>h', 'Goto left window')
bind.nmap('<C-j>', '<C-w>j', 'Goto window below')
bind.nmap('<C-k>', '<C-w>k', 'Goto window above')
bind.nmap('<C-l>', '<C-w>l', 'Goto right window')
bind.nmap('<C-Down>', '<Cmd>resize -5<CR>', 'Decrease window height')
bind.nmap('<C-Up>', '<Cmd>resize +5<CR>', 'Increase window height')
bind.nmap('<C-Left>', '<Cmd>vertical resize -20<CR>', 'Decrease window width')
bind.nmap('<C-Right>', '<Cmd>vertical resize +20<CR>', 'Increase window width')
bind.tmap('<C-h>', M.term_send_esc('<C-h>'), 'Goto left window')
bind.tmap('<C-j>', M.term_send_esc('<C-j>'), 'Goto window below')
bind.tmap('<C-k>', M.term_send_esc('<C-k>'), 'Goto window above')
bind.tmap('<C-l>', M.term_send_esc('<C-l>'), 'Goto right window')
bind.tmap('<C-/>', '<cmd>close<cr>', 'Hide Terminal')
bind.nmap('<Leader>b', M.create_scratch_buf, 'Open a scratch buffer')
