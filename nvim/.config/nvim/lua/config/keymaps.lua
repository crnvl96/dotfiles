return function()
    local f = require('functions')
    local map = f.map()

    map.n('<c-s>', '<esc><cmd>w<cr><esc>')
    map.x('<c-s>', '<esc><cmd>w<cr><esc>')
    map.i('<c-s>', '<esc><cmd>w<cr><esc>')

    map.n('<esc>', '<esc><cmd>noh<cr><esc>')
    map.x('<esc>', '<esc><cmd>noh<cr><esc>')
    map.i('<esc>', '<esc><cmd>noh<cr><esc>')

    map.n('j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    map.x('j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })

    map.n('k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
    map.x('k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

    map.x('p', 'P')

    map.n('Y', 'v$<left>y')
    map.n('<c-d>', '<c-d>zz')
    map.n('<c-u>', '<c-u>zz')
    map.n('n', 'nzzzv')
    map.n('N', 'Nzzzv')
    map.n('*', '*zzzv')
    map.n('#', '#zzzv')

    map.t('<esc><esc>', '<c-\\><c-n>')
    map.t('<C-h>', '<cmd>wincmd h<cr>')
    map.t('<C-j>', '<cmd>wincmd j<cr>')
    map.t('<C-k>', '<cmd>wincmd k<cr>')
    map.t('<C-l>', '<cmd>wincmd l<cr>')
    map.t('<C-/>', '<cmd>close<cr>')
    map.t('<c-_>', '<cmd>close<cr>')

    map.x('<', '<gv')
    map.x('>', '>gv')

    map.n('<c-h>', '<c-w>h')
    map.n('<c-j>', '<c-w>j')
    map.n('<c-k>', '<c-w>k')
    map.n('<c-l>', '<c-w>l')
    map.n('<c-up>', '<cmd>resize +5<cr>')
    map.n('<c-down>', '<cmd>resize -5<cr>')
    map.n('<c-left>', '<cmd>vertical resize -20<cr>')
    map.n('<c-right>', '<cmd>vertical resize +20<cr>')
    map.n('<c-w>+', '<cmd>resize +5<cr>')
    map.n('<c-w>-', '<cmd>resize -5<cr>')
    map.n('<c-w><', '<cmd>vertical resize -20<cr>')
    map.n('<c-w>>', '<cmd>vertical resize +20<cr>')
    map.n('-', '<cmd>Ex<cr>')

    map.n(']t', '<cmd>tabnext<cr>', 'next tab')
    map.n('[t', '<cmd>tabprevious<cr>', 'previous tab')
    map.n('[T', '<cmd>tabfirst<cr>', 'first tab')
    map.n(']T', '<cmd>tablast<cr>', 'last tab')

    map.ln('<tab>o', '<cmd>tabonly<cr>', 'close other tabs')
    map.ln('<tab><tab>', '<cmd>tabnew<cr>', 'new tab')
    map.ln('<tab>d', '<cmd>tabclose<cr>', 'close tab')
end
