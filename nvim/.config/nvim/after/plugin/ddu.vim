call ddu#custom#patch_global(#{
      \  ui: 'ff',
      \  uiParams: #{
      \    ff: #{
      \      ignoreEmpty: v:false,
      \      preview: v:true,
      \      previewSplit: 'vertical',
      \      previewWidth: 120,
      \      onPreview: denops#callback#register(
      \         { args -> execute('normal! zt') }
      \       ),
      \       autoAction: #{
      \         name: 'preview',
      \       },
      \       startAutoAction: v:false,
      \     }
      \  },
      \  sourceOptions: #{
      \    _: #{
      \       matchers: ['matcher_fzf'],
      \       sorters: ['sorter_fzf'],
      \    },
      \  },
      \  kindOptions: #{
      \    file: #{
      \      defaultAction: 'open',
      \    },
      \     action: #{
      \       defaultAction: 'do',
      \    },
      \    ui_select: #{
      \      defaultAction: 'select',
      \    },
      \  },
      \  filterParams: #{
      \     matcher_fzf: #{
      \       highlightMatched: 'Search',
      \     },
      \   }
      \})

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> o <Cmd>call ddu#ui#do_action('chooseAction')<CR>
  nnoremap <buffer><silent> i <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> * <Cmd>call ddu#ui#do_action('toggleAllItems')<CR>
  nnoremap <buffer><silent> <Space> <Cmd>call ddu#ui#do_action('toggleAutoAction')<CR>
  nnoremap <buffer><silent> <Tab> <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> <CR> <Cmd>call ddu#ui#do_action('itemAction')<CR>
  xnoremap <buffer> <Tab> :call ddu#ui#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> <C-c> <Cmd>call ddu#ui#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer> <CR> <Esc><Cmd>call ddu#ui#do_action('leaveFilterWindow')<CR>
  nnoremap <buffer> <CR> <Cmd>call ddu#ui#do_action('leaveFilterWindow')<CR>
  nnoremap <buffer><silent> <C-c> <Cmd>call ddu#ui#do_action('quit')<CR>
  inoremap <buffer><silent> <C-c> <Cmd>call ddu#ui#do_action('quit')<CR>
endfunction

nnoremap <leader>ff <cmd>call ddu#start(#{
      \  sources: [
      \    #{
      \        name: "file_external",
      \        options: #{
      \          converters: [ "converter_devicon" ],
      \        },
      \        params: #{
      \          cmd: split("fd -t f -t l -H -L --color never", " "),
      \        },
      \    }
      \ ]
      \})<CR>

nnoremap <leader>fg <cmd>call ddu#start(#{
      \  sources: [
      \    #{
      \        name: "rg",
      \        options: #{
      \          matchers: [],
      \          volatile: v:true,
      \          converters: [ "converter_devicon" ],
      \          path: getcwd(),
      \        },
      \        params: #{
      \          args: ["--json"],
      \        },
      \     }
      \  ]
      \})<CR>

nnoremap <leader>fb <cmd>call ddu#start(#{
      \  sources: [
      \    #{ name: "buffer" }
      \ ]
      \})<CR>

nnoremap <leader>fl <cmd>call ddu#start(#{
      \  sources: [
      \    #{ name: "line" }
      \ ]
      \})<CR>
