vim9script

if exists("g:loaded_vimcomplete")
    g:VimCompleteOptionsSet({
        completor: {
            shuffleEqualPriority: true,
        },
        path: { enable: true, priority: 12 },
        lsp: { enable: true, priority: 11 },
        buffer: { enable: true, priority: 10 },
        vimscript: { enable: true, priority: 10 },
    })

    g:VimCompleteInfoPopupOptionsSet({
        borderhighlight: ['Comment'],
    })
endif
