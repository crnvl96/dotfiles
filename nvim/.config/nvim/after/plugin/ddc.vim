call pum#set_option(#{
\   item_orders: ['kind', 'space', 'abbr', 'space', 'menu' ],
\	scrollbar_char: '┃',
\	highlight_matches: 'String',
\	preview: v:true,
\	border: 'single',
\	preview_border: 'single',
\	max_height: 82,
\	max_width: 82,
\	preview_height: 82,
\	preview_width: 82,
\})


call ddc#custom#patch_filetype(['lua'], #{
\	sources: [ 'lsp', 'nvim-lua', 'buffer', 'file' ],
\})

call ddc#custom#patch_global(#{
\   ui: 'pum',
\	sources: [ 'lsp', 'buffer', 'file' ],
\	backspaceCompletion: v:true,
\	autoCompleteEvents: [
\		'InsertEnter',
\		'TextChangedI',
\		'CmdlineEnter',
\		'CmdlineChanged',
\	],
\	sourceOptions: #{
\		_: #{
\			matchers: [ 'matcher_fuzzy' ],
\			sorters: [ 'sorter_fuzzy' ],
\			converters: [ 'converter_fuzzy' ],
\			ignoreCase: v:true,
\			timeout: 500,
\		},
\		lsp: #{
\			mark: '(ddc-LSP)',
\			sorters: [ 'sorter_fuzzy' ],
\			dup: 'keep',
\		},
\		nvim-lua: #{
\			mark: '(ddc-Lua)',
\			dup: v:true,
\		},
\		buffer: #{
\			mark: '(ddc-Buffer)',
\		},
\	    file: #{
\	  	    mark: 'F',
\	  	    isVolatile: v:true,
\	  	    forceCompletionPattern: '\S/\S*',
\	    }
\	},
\	sourceParams: #{
\		lsp: #{
\			lspEngine: 'nvim-lsp',
\			confirmBehavior: 'replace',
\			enableResolveItem: v:true,
\			enableAdditionalTextEdit: v:true,
\		},
\		buffer: #{
\			requireSameFiletype: v:false,
\			limitBytes: 5000000,
\			fromAltBuf: v:true,
\			forceCollect: v:true,
\		},
\	},
\})

inoremap <silent> <C-n> <Cmd>call pum#map#insert_relative(+1, 'loop')<CR>
inoremap <silent> <C-p> <Cmd>call pum#map#insert_relative(-1, 'loop')<CR>
inoremap <silent> <C-y> <Cmd>call pum#map#confirm()<CR>
inoremap <silent> <C-f> <Cmd>call pum#map#scroll_preview(+5)<CR>
inoremap <silent> <C-b> <Cmd>call pum#map#scroll_preview(-5)<CR>


function! s:ddc_enable()
	call ddc#enable()
	call ddc#enable_cmdline_completion()
endfunction

augroup DdcAutoCmds
	autocmd!
	autocmd InsertEnter,CmdlineEnter * ++once :call s:ddc_enable()
augroup END
