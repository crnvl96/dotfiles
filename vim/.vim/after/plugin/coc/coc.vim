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

    inoremap <silent><expr> <c-@> coc#refresh()
    nmap <silent> [d <Plug>(coc-diagnostic-prev)
    nmap <silent> ]d <Plug>(coc-diagnostic-next)
    nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
    nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    nmap <leader>cn <Plug>(coc-rename)
    nmap <leader>ca  <Plug>(coc-codeaction-cursor)
    nmap <leader>cA  <Plug>(coc-codeaction-source)
    nmap <silent> <leader>cR <Plug>(coc-codeaction-refactor)
    nmap <silent> <leader>cr  <Plug>(coc-codeaction-refactor-selected)
    xmap <silent> <leader>cr  <Plug>(coc-codeaction-refactor-selected)
    nmap <leader><space>  <Plug>(coc-format-selected)
    xmap <leader><space>  <Plug>(coc-format-selected)
    nmap <leader>cl  <Plug>(coc-codelens-action)
    nnoremap <silent><nowait> <leader>fd  :<C-u>CocList diagnostics<cr>
    nnoremap <silent><nowait> <leader>fs  :<C-u>CocList outline<cr>
    nnoremap <silent><nowait> <leader>fS  :<C-u>CocList -I symbols<cr>
    nnoremap <silent><nowait> <leader>fr  :<C-u>CocListResume<CR>

    nnoremap <silent> <leader>k :call ShowDocumentation()<CR>

    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

    nnoremap <silent><nowait> <leader>Ce  :<C-u>CocList extensions<cr>
    nnoremap <silent><nowait> <leader>Cc  :<C-u>CocList commands<cr>
endif
