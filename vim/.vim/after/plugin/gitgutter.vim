vim9script

if exists("g:loaded_gitgutter")
    g:gitgutter_preview_win_floating = 1
    g:gitgutter_floating_window_options['border'] = 'single'

    def GitGutterOpenQuickfix()
        :GitGutterQuickFixCurrentFile
        copen
    enddef

    nmap ]h <Plug>(GitGutterNextHunk)
    nmap [h <Plug>(GitGutterPrevHunk)
    omap ih <Plug>(GitGutterTextObjectInnerPending)
    omap ah <Plug>(GitGutterTextObjectOuterPending)
    xmap ih <Plug>(GitGutterTextObjectInnerVisual)
    xmap ah <Plug>(GitGutterTextObjectOuterVisual)
    nnoremap <silent> <leader>hq :<c-u> call <SID>GitGutterOpenQuickfix()<CR>

    hi GitGutterAdd ctermfg=5 | hi GitGutterChange ctermfg=5 | hi GitGutterDelete ctermfg=5

    if exists("#gitgutter")
        autocmd! gitgutter QuickFixCmdPre *vimgrep*
        autocmd! gitgutter QuickFixCmdPost *vimgrep*
    endif
endif
