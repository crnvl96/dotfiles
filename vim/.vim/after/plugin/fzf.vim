vim9script

if exists('g:loaded_fzf_vim')
    g:fzf_vim = {}
    g:fzf_vim.preview_window = {}

    g:fzf_layout = { 'down': '60%' }

    command FzfFiles Files
    nnoremap <Leader>ff :FzfFiles<CR>

    command FzfRg Rg
    nnoremap <Leader>fg :FzfRg<CR>

    command FzfBuffers Buffers
    nnoremap <Leader>fb :FzfBuffers<CR>

    command FzfLines BLines
    nnoremap <Leader>fl :FzfLines<CR>

    command FzfMarks Marks
    nnoremap <Leader>fm :FzfMarks<CR>

    command FzfCommands Commands
    nnoremap <Leader>fc :FzfCommands<CR>

    command FzfMaps Maps
    nnoremap <Leader>fk :FzfMaps<CR>
endif
