local k = require('mini.keymap')

k.setup()

local multi = k.map_multistep
local combo = k.map_combo

multi('i', '<C-n>', { 'blink_next', 'pmenu_next' })
multi('i', '<C-p>', { 'blink_prev', 'pmenu_prev' })
multi('i', '<Tab>', { 'blink_next', 'pmenu_next' })
multi('i', '<S-Tab>', { 'blink_prev', 'pmenu_prev' })
multi('i', '<CR>', { 'blink_accept', 'pmenu_accept' })

local mode = { 'i', 'c', 'x', 's' }
combo(mode, 'jk', '<BS><BS><Esc>')
combo(mode, 'kj', '<BS><BS><Esc>')

combo('t', 'jk', '<BS><BS><C-\\><C-n>')
combo('t', 'kj', '<BS><BS><C-\\><C-n>')
