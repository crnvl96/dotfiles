call ddu#custom#patch_global(#{
      \  ui: 'ff',
      \  uiParams: #{
      \    ff: #{
      \      split: 'horizontal',
      \      autoAction: #{
      \        name: "preview",
      \      },
      \      startAutoAction: v:false,
      \      ignoreEmpty: v:false,
      \      previewSplit: 'no',
      \    },
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
      \    lsp: #{
      \      defaultAction: 'open',
      \    },
      \    lsp_codeaction: #{
      \      defaultAction: 'apply',
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
  inoremap <buffer> <CR> <Esc><Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
  nnoremap <buffer> <CR> <Cmd>call ddu#ui#do_action('closeFilterWindow')<CR>
  nnoremap <buffer><silent> <C-c> <Cmd>call ddu#ui#do_action('quit')<CR>
  inoremap <buffer><silent> <C-c> <Cmd>call ddu#ui#do_action('quit')<CR>
endfunction
