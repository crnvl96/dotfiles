vim.ui.select = function(items, opts, on_choice)
    local start_opts = { window = { config = { width = vim.o.columns } } }
    return MiniPick.ui_select(items, opts, on_choice, start_opts)
end

local set = vim.keymap.set

set('n', '<Leader>,', '<Cmd>Pick buffers<CR>', { desc = 'Buffers picker' })
set('n', '<Leader>e', '<Cmd>Pick explorer<CR>', { desc = 'Explorer' })

set('n', '<Leader>ff', '<Cmd>Pick files<CR>', { desc = 'Files' })
set('n', '<Leader>fh', '<Cmd>Pick help<CR>', { desc = 'Help' })
set('n', '<Leader>fo', '<Cmd>Pick oldfiles<CR>', { desc = 'Oldfiles' })
set('n', '<Leader>fk', '<Cmd>Pick keymaps<CR>', { desc = 'Keymaps' })
set('n', '<Leader>fg', '<Cmd>Pick grep_live<CR>', { desc = 'Grep' })
set('n', '<Leader>fr', '<Cmd>Pick resume<CR>', { desc = 'Resume' })
set('n', '<Leader>fl', '<Cmd>Pick buf_lines<CR>', { desc = 'Buffer lines' })

set('n', '<leader>sy', ":<C-U>let @+ = expand('%:.')<CR>", { desc = 'Copy file name to default register' })
set('n', '-', '<Cmd>Yazi<CR>', { desc = 'Yazi' })
