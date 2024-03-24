vim9script

if exists('g:loaded_fzf_vim')
    g:fzf_vim = {}
    g:fzf_vim.preview_window = {}

    g:fzf_layout = { 'down': '60%' }

    nnoremap <silent> <Leader>ff :Files<CR>
    nnoremap <silent> <Leader>fg :Rg<CR>
    nnoremap <silent> <Leader>fb :Buffers<CR>
    nnoremap <silent> <Leader>fl :BLines<CR>
    nnoremap <silent> <Leader>fm :Marks<CR>
    nnoremap <silent> <Leader>fc :Commands<CR>
    nnoremap <silent> <Leader>fk :Maps<CR>
endif
