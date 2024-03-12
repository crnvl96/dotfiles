vim9script

map <silent> <BS> <Nop>
map <silent> <CR> <Nop>
map <silent> <Space> <Nop>

map <silent> Y y$

xnoremap <silent> p \"_dp
xnoremap <silent> P \"_dP
xnoremap <silent> > >gv
xnoremap <silent> < <gv

nnoremap <silent> <esc> :nohls<cr><esc>

nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz

nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :resize -10<CR>
nnoremap <silent> <C-Right> :resize +10<CR>

def VSetSearch(cmdtype: string)
    var temp = getreg('d')
    norm! gv"sy
    setreg('/', '\V' .. substitute(escape(@s, cmdtype .. '\'), '\n', '\\n', 'g'))
    setreg('s', temp)
enddef
xnoremap <silent> * :<c-u> call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<c-u> call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

nnoremap <silent> gp `[v`]
nnoremap <silent> go `]
nnoremap <silent> gO `[

def CopyFileName()
    setreg('+', expand('%:p'))
enddef
nnoremap <silent> <leader>cf :<c-u> call <SID>CopyFileName()<CR>

nnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'

xnoremap <silent> <expr> @ ':norm @' .. getcharstr() .. '<CR>'

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') .. '/' : '%%'

def GitDiffThisFile()
    var fname = resolve(expand('%:p'))
    var dirname = fname->fnamemodify(':p:h')
    exec $'!cd {dirname};git diff {fname}; cd -'
enddef
nnoremap <silent> <leader>d. :<c-u> call <SID>GitDiffThisFile()<CR>

def TmuxSplit()
    system('tmux split-window -h -c "' .. expand("%:p:h") .. '"')
enddef
nnoremap <silent> <leader>T :<c-u> call <SID>TmuxSplit()<CR>
