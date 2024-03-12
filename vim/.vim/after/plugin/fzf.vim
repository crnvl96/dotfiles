vim9script

if exists('g:loaded_fzf_vim')
    g:fzf_vim = {}
    g:fzf_vim.preview_window = {}

    g:fzf_layout = { 'window': { 'width': 0.5, 'height': 0.8 } }

    nnoremap <silent> <Leader>ff :Files<CR>
    nnoremap <silent> <Leader>sg :Rg<CR>
endif
