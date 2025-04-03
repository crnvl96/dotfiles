vim.keymap.set('x', 'p', 'P')

vim.keymap.set('c', '<C-n>', '<Tab>')

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

-- Simple function to handle floating terminals
--
-- https://www.reddit.com/r/neovim/comments/1jovxll/toggle_float_terminal_plug_and_play/
vim.keymap.set(
    { 'n', 't' },
    '<C-t>',
    (function()
        local buf, win = nil, nil
        local was_insert = true
        local cfg = function()
            return {
                relative = 'editor',
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.8),
                row = math.floor(vim.o.lines * 0.1),
                col = math.floor(vim.o.columns * 0.1),
                style = 'minimal',
                border = 'single',
            }
        end
        return function()
            buf = (buf and vim.api.nvim_buf_is_valid(buf)) and buf or nil
            win = (win and vim.api.nvim_win_is_valid(win)) and win or nil
            if not buf and not win then
                vim.cmd('split | terminal')
                buf = vim.api.nvim_get_current_buf()
                vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
                win = vim.api.nvim_open_win(buf, true, cfg())
            elseif not win and buf then
                win = vim.api.nvim_open_win(buf, true, cfg())
            elseif win then
                was_insert = vim.api.nvim_get_mode().mode == 't'
                return vim.api.nvim_win_close(win, true)
            end
            if was_insert then vim.cmd('startinsert') end
        end
    end)(),
    { desc = 'Toggle float terminal' }
)

vim.keymap.set('n', 'Y', YankCmd('yg_'), { expr = true })
vim.keymap.set({ 'n', 'x' }, 'y', YankCmd('y'), { expr = true })

vim.keymap.set({ 'n', 'x' }, '<Leader>cc', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle AI chat' })
vim.keymap.set('x', 'ga', ':CodeCompanionChat Add<CR>', { desc = 'Add to AI chat' })
vim.keymap.set('v', 'ghy', ':GBrowse!<CR>', { desc = 'Copy link' })

vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end, { desc = 'Find files (FZF)' })
vim.keymap.set('n', '<Leader>/', function() require('fzf-lua').live_grep() end, { desc = 'Grep files (FZF)' })
vim.keymap.set('x', '<Leader>/', function() require('fzf-lua').grep_visual() end, { desc = 'Grep visual (FZF)' })

vim.keymap.set('n', '-', function() require('oil').open() end, { desc = 'Oil' })
vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end, { desc = 'Find buffers (FZF)' })
vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end, { desc = 'Resume last finder (FZF)' })
vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end, { desc = 'Quickfix (FZF)' })

vim.keymap.set('c', '<C-n>', function()
    if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 't', true)
    end
    return ''
end, { expr = true, noremap = false })

vim.keymap.set('c', '<C-p>', function()
    if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 't', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 't', true)
    end
    return ''
end, { expr = true, noremap = false })
