local function map(lhs, rhs, opts, mode)
    opts = type(opts) == 'string' and { desc = opts } or opts
    return vim.keymap.set(mode, lhs, rhs, opts)
end

local function nmap(lhs, rhs, opts) return map(lhs, rhs, opts, 'n') end
local function vmap(lhs, rhs, opts) return map(lhs, rhs, opts, 'v') end
local function xmap(lhs, rhs, opts) return map(lhs, rhs, opts, 'x') end
local function imap(lhs, rhs, opts) return map(lhs, rhs, opts, 'i') end
local function tmap(lhs, rhs, opts) return map(lhs, rhs, opts, 't') end
local function lnmap(lhs, rhs, opts, mode) return map('<leader>' .. lhs, rhs, opts, 'n') end

return function()
    nmap('<c-s>', '<esc><cmd>w<cr><esc>')
    xmap('<c-s>', '<esc><cmd>w<cr><esc>')
    imap('<c-s>', '<esc><cmd>w<cr><esc>')

    nmap('<esc>', '<esc><cmd>noh<cr><esc>')
    xmap('<esc>', '<esc><cmd>noh<cr><esc>')
    imap('<esc>', '<esc><cmd>noh<cr><esc>')

    nmap('j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
    xmap('j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })

    nmap('k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
    xmap('k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

    xmap('p', 'P')

    nmap('Y', 'v$<left>y')
    nmap('<c-d>', '<c-d>zz')
    nmap('<c-u>', '<c-u>zz')
    nmap('n', 'nzzzv')
    nmap('N', 'Nzzzv')
    nmap('*', '*zzzv')
    nmap('#', '#zzzv')

    tmap('<esc><esc>', '<c-\\><c-n>')
    tmap('<C-h>', '<cmd>wincmd h<cr>')
    tmap('<C-j>', '<cmd>wincmd j<cr>')
    tmap('<C-k>', '<cmd>wincmd k<cr>')
    tmap('<C-l>', '<cmd>wincmd l<cr>')
    tmap('<C-/>', '<cmd>close<cr>')
    tmap('<c-_>', '<cmd>close<cr>')

    vmap('<', '<gv')
    vmap('>', '>gv')

    nmap('<c-h>', '<c-w>h')
    nmap('<c-j>', '<c-w>j')
    nmap('<c-k>', '<c-w>k')
    nmap('<c-l>', '<c-w>l')
    nmap('<c-up>', '<cmd>resize +5<cr>')
    nmap('<c-down>', '<cmd>resize -5<cr>')
    nmap('<c-left>', '<cmd>vertical resize -20<cr>')
    nmap('<c-right>', '<cmd>vertical resize +20<cr>')
    nmap('<c-w>+', '<cmd>resize +5<cr>')
    nmap('<c-w>-', '<cmd>resize -5<cr>')
    nmap('<c-w><', '<cmd>vertical resize -20<cr>')
    nmap('<c-w>>', '<cmd>vertical resize +20<cr>')
    nmap('-', '<cmd>Ex<cr>')

    nmap(']t', '<cmd>tabnext<cr>', 'next tab')
    nmap('[t', '<cmd>tabprevious<cr>', 'previous tab')
    nmap('[T', '<cmd>tabfirst<cr>', 'first tab')
    nmap(']T', '<cmd>tablast<cr>', 'last tab')

    lnmap('<tab>o', '<cmd>tabonly<cr>', 'close other tabs')
    lnmap('<tab><tab>', '<cmd>tabnew<cr>', 'new tab')
    lnmap('<tab>d', '<cmd>tabclose<cr>', 'close tab')
end
