-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    local lhs = '<C-' .. key .. '>'

    vim.keymap.set({ 'n', 'v', 'i' }, lhs, function()
        local function feed(k, m) return vim.api.nvim_feedkeys(k, m, true) end

        local mode = string.lower(vim.api.nvim_get_mode().mode)
        local keycode = vim.api.nvim_replace_termcodes(key, true, false, true)

        local termcodes = {
            c_w = vim.api.nvim_replace_termcodes('<C-w>', true, false, true),
            esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
        }

        local modes = {
            i = vim.startswith(mode, 'i'),
            v = vim.startswith(mode, 'v'),
        }

        if modes.i then feed(termcodes.esc, 'n') end
        if modes.v then feed(termcodes.esc, 'n') end

        feed(termcodes.c_w, 't')
        feed(keycode, 't')
    end, { expr = true })
end

vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>', { desc = 'Clear highlight' })

vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w<CR><Esc>', { desc = 'Save' })

vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Move down' })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Move up' })

vim.keymap.set('n', '#', '#zzzv', { desc = 'Search current word backward' })
vim.keymap.set('n', '*', '*zzzv', { desc = 'Search current word forward' })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>', { remap = true, desc = 'Resize height -' })
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>', { remap = true, desc = 'Resize width -' })
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>', { remap = true, desc = 'Resize width +' })
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>', { remap = true, desc = 'Resize height +' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })
vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>', { remap = true, desc = 'Resize height +' })
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>', { remap = true, desc = 'Resize height -' })
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>', { remap = true, desc = 'Resize width -' })
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>', { remap = true, desc = 'Resize width +' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zzzv'", { expr = true, desc = 'Search backward' })
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = 'Search forward' })
vim.keymap.set('x', '<', '<gv', { desc = 'Indent left' })
vim.keymap.set('x', '>', '>gv', { desc = 'Indent right' })
vim.keymap.set('x', 'p', 'P', { desc = 'Better paste' })
