vim9script

if exists('g:did_coc_loaded')
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    augroup CocGo
        autocmd!
        autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
        autocmd FileType go nmap gtj :CocCommand go.tags.add json<cr>
        autocmd FileType go nmap gty :CocCommand go.tags.add yaml<cr>
        autocmd FileType go nmap gtx :CocCommand go.tags.clear<cr>
    augroup end

    augroup coc
        autocmd!
        autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
        autocmd CursorHold * silent call CocActionAsync('highlight')
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
    # Use <c-space> to trigger completion
    inoremap <expr> <c-@> coc#refresh()
    nmap [d <Plug>(coc-diagnostic-prev)
    nmap ]d <Plug>(coc-diagnostic-next)
    nmap [e <Plug>(coc-diagnostic-prev-error)
    nmap ]e <Plug>(coc-diagnostic-next-error)
    nmap gd <Plug>(coc-definition)
    nmap gy <Plug>(coc-type-definition)
    nmap gi <Plug>(coc-implementation)
    nmap gr <Plug>(coc-references)
    nmap <leader>cn <Plug>(coc-rename)
    nmap <leader>ca <Plug>(coc-codeaction-cursor)
    nmap <leader>cA <Plug>(coc-codeaction-source)
    nmap <leader>cR <Plug>(coc-codeaction-refactor)
    nmap <leader>cr  <Plug>(coc-codeaction-refactor-selected)
    xmap <leader>cr  <Plug>(coc-codeaction-refactor-selected)
    nmap <leader><space>  <Plug>(coc-format-selected)
    xmap <leader><space>  <Plug>(coc-format-selected)
    nmap <leader>cl  <Plug>(coc-codelens-action)
    nnoremap <nowait> <leader>fd  :<C-u>CocList diagnostics<cr>
    nnoremap <nowait> <leader>fs  :<C-u>CocList outline<cr>
    nnoremap <nowait> <leader>fS  :<C-u>CocList -I symbols<cr>
    nnoremap <nowait> <leader>fr  :<C-u>CocListResume<CR>
    nnoremap <leader>k :call ShowDocumentation()<CR>
    nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : ""
    nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : ""
    inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : ""
    inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : ""
    vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : ""
    vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : ""

    nnoremap <nowait> <leader>Ce  :<C-u>CocList extensions<cr>
    nnoremap <nowait> <leader>Cc  :<C-u>CocList commands<cr>
endif
