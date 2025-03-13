set background=dark

hi clear

let g:colors_name = 'ham'
set notermguicolors

" This color scheme relies on ANSI colors only. It automatically inherits
" the 16 colors of your terminal color scheme. You can change the colors of
" certain highlight groups by picking a different color from the following set
" of colors. If you sticked to the ANSI color palette conventions when setting
" colors in your terminal emulator, this will look pretty neat. If you used
" a terminal color scheme that uses a different convention (e.g. base16)
" colors will likely look very odd if you use this color scheme.
"
" 0: Black        │   8: Bright Black (dark gray)
" 1: Red          │   9: Bright Red
" 2: Green        │  10: Bright Green
" 3: Yellow       │  11: Bright Yellow
" 4: Blue         │  12: Bright Blue
" 5: Magenta      │  13: Bright Magenta
" 6: Cyan         │  14: Bright Cyan
" 7: White (gray) │  15: Bright White

" Use the 'cterm' argument to make certain highlight groups appear in italic
" (if your terminal and font support it), bold, reverse, underlined, etc.
" See ':help attr-list' for possible options.

" Editor
hi Bold              cterm=bold
hi ColorColumn       ctermbg=8
hi Conceal           ctermfg=8
hi CurSearch         ctermbg=3    ctermfg=0
hi Cursor            ctermbg=15   ctermfg=0
hi CursorColumn      ctermbg=0
hi CursorLine        ctermbg=0    ctermfg=NONE
hi CursorLineNr      ctermfg=6
hi DiffAdd           ctermbg=10   ctermfg=0
hi DiffChange        ctermbg=12   ctermfg=0
hi DiffDelete        ctermbg=9    ctermfg=0
hi DiffText          ctermbg=14   ctermfg=0
hi Directory         ctermfg=4
hi ErrorMsg          ctermfg=1    cterm=bold,italic
hi FloatBorder       ctermbg=NONE ctermfg=7
hi FloatShadow       ctermbg=NONE ctermfg=15
hi FoldColumn        ctermfg=7
hi Folded            ctermfg=12
hi Ignore            ctermfg=NONE ctermbg=NONE cterm=NONE
hi IncSearch         ctermbg=1    ctermfg=0
hi Italic            cterm=italic
hi LineNr            ctermfg=8
hi LspReferenceRead  cterm=underline
hi LspReferenceText  cterm=underline
hi LspReferenceWrite cterm=underline
hi MatchParen        ctermbg=0    ctermfg=3    cterm=underline
hi ModeMsg           ctermbg=15   ctermfg=0    cterm=bold
hi MoreMsg           ctermfg=4
hi NonText           ctermfg=2    ctermbg=NONE
hi Normal            ctermbg=NONE ctermfg=15
hi NormalFloat       ctermbg=NONE ctermfg=15
hi Pmenu             ctermbg=7    ctermfg=0
hi PmenuSbar         ctermbg=NONE ctermfg=NONE
hi PmenuSel          ctermbg=NONE ctermfg=8    cterm=bold
hi PmenuThumb        ctermbg=NONE ctermfg=NONE
hi Question          ctermfg=4
hi QuickFixLine      ctermbg=NONE ctermfg=14 cterm=bold
hi Search            ctermbg=11   ctermfg=0
hi SignColumn        ctermfg=7
hi SpecialKey        ctermfg=0
hi SpellBad          cterm=undercurl
hi SpellCap          cterm=undercurl
hi SpellLocal        cterm=undercurl
hi SpellRare         cterm=undercurl
hi StatusLine        ctermfg=15   ctermbg=0    cterm=NONE
hi StatusLineNC      ctermfg=15   ctermbg=0    cterm=NONE
hi TabLine           ctermfg=7    ctermbg=0
hi TabLineFill       ctermfg=0    ctermbg=NONE
hi TabLineSel        ctermfg=0    ctermbg=11
hi Title             ctermfg=4    cterm=bold
hi ToolbarButton     ctermbg=8    ctermfg=15
hi ToolbarLine       ctermbg=0    ctermfg=15
hi Underlined        cterm=underline
hi VertSplit         ctermfg=8
hi Visual            ctermbg=8    ctermfg=15   cterm=bold
hi VisualNOS         ctermbg=8    ctermfg=15   cterm=bold
hi WarningMsg        ctermfg=11
hi WildMenu          ctermbg=0    ctermfg=15   cterm=NONE
hi debugBreakpoint   ctermfg=8
hi debugPC           ctermfg=7
hi diffAdded         ctermfg=10
hi diffChanged       ctermfg=12
hi diffFile          ctermfg=12
hi diffIndexLine     ctermfg=14
hi diffLine          ctermfg=7
hi diffNewFile       ctermfg=13
hi diffOldFile       ctermfg=11
hi diffRemoved       ctermfg=9
hi healthError       ctermfg=1
hi healthSuccess     ctermfg=2
hi healthWarning     ctermfg=3
hi helpLeadBlank     ctermbg=NONE ctermfg=NONE
hi helpNormal        ctermbg=NONE ctermfg=NONE

" Syntax
hi Boolean      ctermfg=3
hi Comment      ctermfg=8 cterm=italic
hi Conditional  ctermfg=5
hi Constant     ctermfg=3
hi Error        ctermfg=1
hi Exception    ctermfg=5
hi Function     ctermfg=4
hi Identifier   ctermfg=9
hi Include      ctermfg=5
hi Keyword      ctermfg=5
hi Label        ctermfg=14
hi Macro        ctermfg=5
hi Operator     ctermfg=6
hi PreProc      ctermfg=13
hi Special      ctermfg=13
hi Statement    ctermfg=5
hi StorageClass ctermfg=11
hi String       ctermfg=2
hi Structure    ctermfg=11
hi Todo         ctermfg=0 ctermbg=9 cterm=bold
hi Type         ctermfg=11

" Treesitter
" :help treesitter-highlight-groups
hi @variable.member ctermfg=4
