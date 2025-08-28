local map = require('mini.keymap')

map.setup()

map.map_multistep('i', '<C-n>', { 'blink_next', 'pmenu_next' })
map.map_multistep('i', '<C-p>', { 'blink_prev', 'pmenu_prev' })
map.map_multistep('i', '<Tab>', { 'blink_next', 'pmenu_next' })
map.map_multistep('i', '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
map.map_multistep('i', '<CR>', { 'blink_accept', 'pmenu_accept' })
map.map_combo({ 'i', 'c', 'x', 's' }, 'jk', '<BS><BS><Esc>')
map.map_combo({ 'i', 'c', 'x', 's' }, 'kj', '<BS><BS><Esc>')
map.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
map.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')
