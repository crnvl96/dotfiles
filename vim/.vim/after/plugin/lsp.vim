vim9script

if exists("g:loaded_lsp")
    g:LspOptionsSet({
        useQuickfixForLocations: true,
        autoHighlightDiags: true,
        showDiagWithVirtualText: true, # when you set this false, set showDiagOnStatusLine true
        highlightDiagInline: true,
        showDiagOnStatusLine: true,
        diagVirtualTextAlign: 'after',
        autoPopulateDiags: true, # add diags to location list automatically <- :lopen [l ]l
        completionMatcher: 'case', # case/fuzzy/icase
        diagSignErrorText: '●',
        diagSignHintText: '●',
        diagSignInfoText: '●',
        diagSignWarningText: '●',
        showSignature: true,
        echoSignature: true,
        useBufferCompletion: true,
        completionTextEdit: true,
        ignoreMissingServer: true,
    })

    # setlocal formatexpr=lsp#lsp#FormatExpr()

    if executable('gopls')
        g:LspAddServer([{
            name: 'golang',
            filetype: ['go', 'gomod'],
            path: exepath('gopls'),
            args: ['serve'],
            syncInit: true
        }])
    endif
    if executable('typescript-language-server')
        g:LspAddServer([
            {
                name: 'tsserver',
                filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
                path: exepath('typescript-language-server'),
                args: ['--stdio'],
                features: {
                    completionTextEdit: true
                }
            },
            {
                filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
                path: exepath('efm-langserver'),
                args: [],
                initializationOptions: {
                    documentFormatting: true
                },
                features: {
                    documentFormatting: true
                },
                workspaceConfig: {
                    languages: {
                        javascript: [
                            {
                                lintCommand: "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
                                lintStdin: true,
                                formatCommand: 'prettierd --stdin-filepath ${INPUT}',
                                formatStdin: true
                            }
                        ],
                        typescript: [
                            {
                                lintCommand: "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
                                lintStdin: true,
                                formatCommand: 'prettierd --stdin-filepath "${INPUT}"',
                                formatStdin: true
                            }
                        ]
                    }
                },
            }
        ])
    endif
    def LSPUserSetup()
        nnoremap <buffer> [e :LspDiagPrev<CR>|
        nnoremap <buffer> ]e :LspDiagNext<CR>
        if &background == 'dark'
            highlight  LspDiagVirtualTextError    ctermbg=none  ctermfg=1
            highlight  LspDiagVirtualTextWarning  ctermbg=none  ctermfg=3
            highlight  LspDiagVirtualTextHint     ctermbg=none  ctermfg=2
            highlight  LspDiagVirtualTextInfo     ctermbg=none  ctermfg=5
        endif
        highlight  link  LspDiagSignErrorText    LspDiagVirtualTextError
        highlight  link  LspDiagSignWarningText  LspDiagVirtualTextWarning
        highlight  link  LspDiagSignHintText     LspDiagVirtualTextHint
        highlight  link  LspDiagSignInfoText     LspDiagVirtualTextInfo
        highlight LspDiagInlineWarning ctermfg=none
        highlight LspDiagInlineHint ctermfg=none
        highlight LspDiagInlineInfo ctermfg=none
        highlight LspDiagInlineError ctermfg=none cterm=undercurl
        highlight LspDiagVirtualText ctermfg=1
        highlight LspDiagLine ctermbg=none

        augroup LspFmt | autocmd!
            autocmd BufWritePre * LspFormat
        augroup END
    enddef


    augroup LspAutocmds | autocmd!
        autocmd User LspAttached LSPUserSetup()
    augroup END

    nnoremap <silent> <leader>ca :LspCodeAction<CR>
    nnoremap <silent> <leader>cd :LspDiagCurrent<CR>
    nnoremap <silent> <leader>sd :LspDiagShow<CR>
    nnoremap <silent> <leader><space> :LspFormat<CR>
    xnoremap <silent> <leader><space> :LspFormat<CR>
    nnoremap <silent> gd :LspGotoDefinition<CR>
    nnoremap <silent> gD :LspGotoDeclaration<CR>
    nnoremap <silent> gr :LspShowReferences<CR>
    nnoremap <silent> gi :LspGotoImpl<CR>
    nnoremap <silent> gy :LspGotoTypeDef<CR>
    inoremap <C-k> :LspShowSignature<CR>
    nnoremap <silent> <leader>k :LspHover<CR>
    nnoremap <silent> ]d :LspDiag next<CR>
    nnoremap <silent> [d :LspDiag prev<CR>
endif
