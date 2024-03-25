let g:signature_help_config = #{
            \  contentsStyle: 'full',
            \  viewStyle: 'floating'
            \}

call pum#set_option(#{
            \  border: 'single',
            \  follow_cursor: v:true,
            \  preview: v:true,
            \  preview_border: 'single',
            \})

call ddc#custom#patch_global(#{
            \  sources: ['lsp', 'around', 'file', 'cmdline'],
            \  ui: 'pum',
            \  autoCompleteEvents: [
            \    'InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged', 'CmdlineEnter',
            \  ],
            \  cmdlineSources: {
            \    ':': ['cmdline-history', 'cmdline', 'around'],
            \    '/': ['around', 'line'],
            \    '?': ['around', 'line'],
            \  },
            \  backspaceCompletion: v:true,
            \  sourceOptions: #{
            \    _: #{
            \      matchers: ['matcher_fuzzy'],
            \      sorters: ['sorter_fuzzy'],
            \      converters: ['converter_fuzzy'],
            \      minAutoCompleteLength: 1,
            \      keywordPattern: '(?:-?\d+(?:\.\d+)?|[a-zA-Z_]\w*(?:-\w*)*)',
            \      ignoreCase: v:true,
            \      timeout: 500,
            \    },
            \    around: #{ mark: '(ddc-Around)' },
            \    lsp: #{
            \      mark: '(ddc-Lsp)',
            \      forceCompletionPattern: '\.\w*|:\w*|->\w*',
            \    },
            \    file: #{
            \      mark: '(ddc-File)',
            \      isVolatile: v:true,
            \      forceCompletionPattern: '\S/\S*',
            \    },
            \    cmdline: #{
            \      mark: '(ddc-Cmd)',
            \      keywordPattern: '[\\w#:~_-]*'
            \    },
            \    line: #{ mark: '(ddc-Line)' },
            \   cmdline-history: #{ mark: '(ddc-CmdH)' },
            \  },
            \  sourceParams: #{
            \    lsp: #{
            \      enableResolveItem: v:true,
            \      lspEngine: 'nvim-lsp',
            \      confirmBehavior: 'replace',
            \      enableAdditionalTextEdit: v:true,
            \    },
            \    around: #{ maxSize: 500 },
            \    converter_fuzzy: #{
            \      hlGroup: 'SpellBad'
            \    },
            \    line: #{ maxSize: 1000 },
            \  },
            \})

inoremap <C-space> <Cmd>call ddc#map#manual_complete()<CR>
inoremap <C-p> <Cmd>call pum#map#select_relative(-1)<CR>
inoremap <C-n> <Cmd>call pum#map#select_relative(+1)<CR>
inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <C-e> <Cmd>call pum#map#cancel()<CR>
inoremap <C-f> <cmd>call pum#map#scroll_preview(+5)<CR>
inoremap <C-b> <cmd>call pum#map#scroll_preview(-5)<CR>

nnoremap : <Cmd>call CommandlinePre()<CR>:
nnoremap / <Cmd>call CommandlinePre()<CR>/
nnoremap ? <Cmd>call CommandlinePre()<CR>?

function! CommandlinePre() abort
    cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
    cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
    cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
    cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
    cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
    cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>

    autocmd User DDCCmdlineLeave ++once call CommandlinePost()

    call ddc#enable_cmdline_completion()
endfunction

function! CommandlinePost() abort
    silent! cunmap <Tab>
    silent! cunmap <S-Tab>
    silent! cunmap <C-n>
    silent! cunmap <C-p>
    silent! cunmap <C-y>
    silent! cunmap <C-e>
endfunction

call ddc#enable()
