local set = vim.keymap.set

set({ 'n', 'x' }, '<leader>as', '<cmd>AiderTerminalSend<cr>', { desc = 'Send to Aider' })
set({ 'n', 'x' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle AI chat' })

set('n', '-', '<Cmd>lua Snacks.picker.explorer()<CR>', { desc = 'File Explorer' })
set('x', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to AI chat' })

set('n', '<Leader>,', '<Cmd>FzfLua buffers<CR>', { desc = 'Buffers picker' })
set('n', '<Leader>ff', '<Cmd>lua Snacks.picker.files()<CR>', { desc = 'Files' })
set('n', '<Leader>fh', '<Cmd>lua Snacks.picker.help()<CR>', { desc = 'Help' })
set('n', '<Leader>fo', '<Cmd>lua Snacks.picker.recent()<CR>', { desc = 'Oldfiles' })
set('n', '<Leader>fg', '<Cmd>lua Snacks.picker.grep()<CR>', { desc = 'Grep' })
set('n', '<Leader>fr', '<Cmd>lua Snacks.picker.resume()<CR>', { desc = 'Resume' })
set('n', '<Leader>fl', '<Cmd>lua Snacks.picker.lines()<CR>', { desc = 'Buffer lines' })
set('n', '<leader>ca', '<cmd>AiderTerminalToggle<cr>', { desc = 'Open Aider' })
set('n', '<leader>cs', '<cmd>AiderQuickSendCommand<cr>', { desc = 'Send Command To Aider' })
set('n', '<leader>cb', '<cmd>AiderQuickSendBuffer<cr>', { desc = 'Send Buffer To Aider' })
set('n', '<leader>c+', '<cmd>AiderQuickAddFile<cr>', { desc = 'Add File to Aider' })
set('n', '<leader>c-', '<cmd>AiderQuickDropFile<cr>', { desc = 'Drop File from Aider' })
set('n', '<leader>cf', '<cmd>AiderQuickReadOnlyFile<cr>', { desc = 'Add File as Read-Only' })
