MiniDeps.later(function()
  require('mini.keymap').setup()

  local map_multistep = require('mini.keymap').map_multistep
  local map_combo = require('mini.keymap').map_combo

  map_multistep('i', '<C-n>', { 'blink_next' })
  map_multistep('i', '<C-p>', { 'blink_prev' })
  map_multistep('i', '<CR>', { 'blink_accept' })

  map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
  map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
  map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
  map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
end)
