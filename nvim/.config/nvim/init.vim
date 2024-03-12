let g:whoami = "crnvl96"

let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"

let g:loaded_netrwPlugin = 1
let g:loaded_netrw = 1

set autoindent
set background=dark
set breakindent
set clipboard=unnamedplus
set cmdheight=1
set complete-=i
set cursorline
set diffopt+=context:99
set expandtab
set fillchars=vert:│,fold:۰,diff:·,stl:─,stlnc:═
set nofoldenable
set grepprg=rg\ --vimgrep
set foldmethod=indent
set formatoptions=qjl
set grepprg=rg\ --vimgrep
set grepformat=%f:%l:%c:%m
set hidden
set hls
set ignorecase
set infercase
set nojoinspaces
set laststatus=2
set linebreak
set list
set listchars=tab:\ \ ,trail:~,eol:↵
set mouse=a
set number
set path+=**
set shortmess+=I
set relativenumber
set scrolloff=8
set shiftround
set shiftwidth=4
set shortmess+=I
set noshowcmd
set pumheight=7
set report=0
set showmatch
set signcolumn=yes
set sidescrolloff=16
set smartcase
set smartindent
set spellsuggest=best,10
set splitbelow
set splitright
set noswapfile
set tabstop=4
set tags=./tags,./../tags,./*/tags
set termguicolors
set timeoutlen=1000
set undofile
set undodir=~/.local/share/nvim/undo
set updatetime=200
set virtualedit=block
set whichwrap+=<,>,h,l
set wildmode=longest:full
set wildignore+=*/node_modules/*,*/dist/*,*/.cache/*
set wildoptions=pum
set nowrap

let g:denops#deno = '/home/crnvl96/.local/share/nvim/mason/bin/deno'

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }

Plug 'cocopon/iceberg.vim'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-fugitive'

Plug 'junegunn/fzf.vim'

Plug 'williamboman/mason-lspconfig.nvim'
Plug 'Shougo/ddc-source-lsp'

Plug 'vim-denops/denops.vim'
Plug 'uga-rosa/ddc-source-nvim-lua'
Plug 'matsui54/ddc-source-buffer'
Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc-ui-pum'
Plug 'LumaKernel/ddc-source-file'
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/ddc.vim'

Plug 'neovim/nvim-lspconfig'
call plug#end()

colorscheme iceberg
