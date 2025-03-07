if vim.fn.has('nvim-0.11') == 1 then
    vim.opt.completeopt:append('fuzzy')
    vim.opt.wildoptions:append('fuzzy')
end

local set = vim.keymap.set

set('n', '<Leader>,', '<Cmd>FzfLua buffers<CR>', { desc = 'Buffers picker' })

set('n', '<Leader>ff', '<Cmd>FzfLua files<CR>', { desc = 'Files' })
set('n', '<Leader>fh', '<Cmd>FzfLua helptags<CR>', { desc = 'Help' })
set('n', '<Leader>fo', '<Cmd>FzfLua oldfiles<CR>', { desc = 'Oldfiles' })
set('n', '<Leader>fk', '<Cmd>FzfLua keymaps<CR>', { desc = 'Keymaps' })
set('n', '<Leader>fg', '<Cmd>FzfLua live_grep_glob<CR>', { desc = 'Grep' })
set('n', '<Leader>fr', '<Cmd>FzfLua resume<CR>', { desc = 'Resume' })
set('n', '<Leader>fl', '<Cmd>FzfLua blines<CR>', { desc = 'Buffer lines' })

set('n', '-', '<Cmd>Yazi<CR>', { desc = 'Yazi' })

set({ 'n', 'x' }, '<leader>as', '<cmd>AiderTerminalSend<cr>', { desc = 'Send to Aider' })
set('n', '<leader>a/', '<cmd>AiderTerminalToggle<cr>', { desc = 'Open Aider' })
set('n', '<leader>ac', '<cmd>AiderQuickSendCommand<cr>', { desc = 'Send Command To Aider' })
set('n', '<leader>ab', '<cmd>AiderQuickSendBuffer<cr>', { desc = 'Send Buffer To Aider' })
set('n', '<leader>a+', '<cmd>AiderQuickAddFile<cr>', { desc = 'Add File to Aider' })
set('n', '<leader>a-', '<cmd>AiderQuickDropFile<cr>', { desc = 'Drop File from Aider' })
set('n', '<leader>ar', '<cmd>AiderQuickReadOnlyFile<cr>', { desc = 'Add File as Read-Only' })
