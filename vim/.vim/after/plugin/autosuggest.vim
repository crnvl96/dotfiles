vim9script

if exists("g:loaded_autosuggest")
    g:AutoSuggestSetup({
        search: {
            fuzzy: true,
            maxheight: 24,
            hidestatusline: false,
        },
        cmd: {
            hidestatusline: false,
            fuzzy: true,
            maxheight: 24,
            exclude: ['^buffer '],
            onspace: ['buffer'],
            editcmdworkaround: true,
        }
    })
endif
