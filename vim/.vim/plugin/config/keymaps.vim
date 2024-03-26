vim9script

nnoremap <silent> <expr> <esc> ':nohls<cr><esc>'

map <BS> <Nop>
map <CR> <Nop>
map <Space> <Nop>

map Y y$
map - :Ex<CR>

xnoremap p "_dp
xnoremap P "_dP
xnoremap > >gv
xnoremap < <gv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

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

def VSetSearch(cmdtype: string)
    var temp = getreg('d')
    norm! gv"sy
    setreg('/', '\V' .. substitute(escape(@s, cmdtype .. '\'), '\n', '\\n', 'g'))
    setreg('s', temp)
enddef
xnoremap <silent> * :<c-u> call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<c-u> call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
xnoremap <C-_> <Esc>/\%V

def MarksDel()
    delm! | delm A-Z0-9a-z
enddef
command MarksDel MarksDel()
nnoremap <leader>md :MarksDel<CR>

def TmuxSplit()
    system('tmux split-window -h -c "' .. expand("%:p:h") .. '"')
enddef
command TmuxSplit TmuxSplit()
nnoremap <leader>T :TmuxSplit<CR>

def FileCopyPath()
    setreg('+', expand('%:p'))
enddef
command FileCopyPath FileCopyPath()
nnoremap <leader>cf :FileCopyPath<CR>
