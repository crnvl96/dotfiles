vim9script

if exists("g:loaded_vimcomplete")
    g:vimcomplete_tab_enable = 1

    g:VimCompleteOptionsSet({
        completor: { shuffleEqualPriority: true, alwaysOn: true, kindDisplayType: 'icontext' },
        buffer: { enable: true, maxCount: 10, priority: 11, urlComplete: true, envComplete: true, completionMatcher: 'icase' },
        abbrev: { enable: true },
        lsp: { enable: true, maxCount: 10, priority: 8 },
        omnifunc: { enable: false, priority: 10, filetypes: ['python', 'javascript'] },
        vimscript: { enable: true, priority: 10 },
    })
    g:VimCompleteInfoPopupOptionsSet({
        borderhighlight: ['Comment'],
    })
endif
