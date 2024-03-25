vim9script

if exists('g:loaded_fzf_vim')
    g:fzf_vim = {}
    g:fzf_vim.preview_window = {}

    g:fzf_layout = { 'down': '60%' }

    nnoremap <Leader>ff :Files<CR>
    nnoremap <Leader>fg :Rg<CR>
    nnoremap <Leader>fb :Buffers<CR>
    nnoremap <Leader>fl :BLines<CR>
    nnoremap <Leader>fm :Marks<CR>
    nnoremap <Leader>fc :Commands<CR>
    nnoremap <Leader>fk :Maps<CR>
endif
