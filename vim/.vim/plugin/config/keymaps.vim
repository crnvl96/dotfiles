vim9script

autocmd VimEnter * nnoremap <silent> <expr> <esc> exists('g:loaded_fFtTplus') ? ':nohls<cr><Plug>(fFtTplus-esc)' : ':nohls<cr><esc>'

def VSetSearch(cmdtype: string)
    var temp = getreg('d')
    norm! gv"sy
    setreg('/', '\V' .. substitute(escape(@s, cmdtype .. '\'), '\n', '\\n', 'g'))
    setreg('s', temp)
enddef

map <silent> <BS> <Nop>
map <silent> <CR> <Nop>
map <silent> <Space> <Nop>

map <silent> Y y$
map <silent> V _v$
map <silent> - :Ex<CR>

xnoremap <silent> p "_dp
xnoremap <silent> P "_dP
xnoremap <silent> > >gv
xnoremap <silent> < <gv
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz

nnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize -10<CR>
nnoremap <silent> <C-Right> :vertical resize +10<CR>

nnoremap <silent> > :bnext<CR>
nnoremap <silent> < :bprev<CR>
nnoremap <silent> X :bw<CR>
nnoremap <silent> <leader>bx :%bd\|e#\|bd#<CR>
nnoremap <silent> <leader>bb :b#<CR>

nnoremap <silent> gp `[v`]
nnoremap <silent> go `]
nnoremap <silent> gO `[

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') .. '/' : '%%'
xnoremap <silent> <expr> @ ':norm @' .. getcharstr() .. '<CR>'

xnoremap <silent> * :<c-u> call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<c-u> call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
xnoremap <C-_> <Esc>/\%V
