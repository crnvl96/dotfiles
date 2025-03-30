vim.keymap.set('x', 'p', 'P')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+y$', { desc = 'Copy to clipboard' })
vim.keymap.set('n', 'gY', ":<C-U>let @+ = expand('%:.')<CR>", { desc = 'Copy file name to default register' })
vim.keymap.set('n', 'gP', '`[v`]', { desc = 'Select pasted text' })
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<C-x>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set('n', 'Y', YankCmd('yg_'), { expr = true })
vim.keymap.set({ 'n', 'x' }, 'y', YankCmd('y'), { expr = true })

vim.keymap.set({ 'n', 'x' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle AI chat' })
vim.keymap.set('x', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to AI chat' })
vim.keymap.set('v', 'ghy', ':GBrowse!<CR>', { desc = 'Copy link' })

vim.keymap.set('n', '-', function() require('oil').open() end, { desc = 'Oil' })
vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end, { desc = 'Find files (FZF)' })
vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end, { desc = 'Find buffers (FZF)' })
vim.keymap.set('n', '<Leader>/', function() require('fzf-lua').live_grep() end, { desc = 'Grep files (FZF)' })
vim.keymap.set('x', '<Leader>/', function() require('fzf-lua').grep_visual() end, { desc = 'Grep visual (FZF)' })
vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end, { desc = 'Resume last finder (FZF)' })
vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end, { desc = 'Quickfix (FZF)' })
vim.keymap.set('n', 'gd', function() require('fzf-lua').lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() require('fzf-lua').lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function() require('fzf-lua').lsp_references() end, { nowait = true, desc = 'References' })
vim.keymap.set('n', 'gi', function() require('fzf-lua').lsp_implementations() end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function() require('fzf-lua').lsp_typedefs() end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', 'ge', function() require('fzf-lua').lsp_document_diagnostics() end, { desc = 'Diagnostics' })
vim.keymap.set('n', 'gs', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'LSP Symbols' })
vim.keymap.set('n', 'gS', function() require('fzf-lua').lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })

vim.keymap.set(
    'ca',
    'cc',
    function() return (vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'cc') and 'Codecompanion' or 'cc' end,
    { expr = true }
)

vim.keymap.set(
    'ca',
    'ccc',
    function()
        return (vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'ccc') and 'CodecompanionChat Toggle' or 'ccc'
    end,
    { expr = true }
)
