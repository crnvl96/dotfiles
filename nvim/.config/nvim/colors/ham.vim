hi clear

let g:colors_name = 'ham'

" Automatically adapt to background setting
if &background ==# 'dark'
  " Editor (Minimal - Dark Terminal ANSI)
  hi Cursor            ctermbg=15   ctermfg=0
  hi CursorLine        ctermbg=0    ctermfg=NONE
  hi CursorLineNr      ctermfg=6
  hi DiffAdd           ctermbg=10   ctermfg=0
  hi DiffChange        ctermbg=12   ctermfg=0
  hi DiffDelete        ctermbg=9    ctermfg=0
  hi DiffText          ctermbg=14   ctermfg=0
  hi EndOfBuffer       ctermfg=8
  hi ErrorMsg          ctermfg=1    cterm=bold,italic
  hi IncSearch         ctermbg=1    ctermfg=0
  hi LineNr            ctermfg=8
  hi MatchParen        ctermbg=0    ctermfg=3    cterm=underline,bold
  hi ModeMsg           ctermbg=15   ctermfg=0    cterm=bold
  hi MoreMsg           ctermfg=4
  hi NonText           ctermfg=8
  hi Normal            ctermbg=NONE ctermfg=15
  hi NormalFloat       ctermbg=NONE ctermfg=15
  hi Pmenu             ctermbg=7    ctermfg=0
  hi PmenuSel          ctermbg=8    ctermfg=15   cterm=bold
  hi Search            ctermbg=11   ctermfg=0
  hi SignColumn        ctermfg=7
  hi SpellBad          cterm=undercurl ctermfg=1
  hi StatusLine        ctermfg=15   ctermbg=0    cterm=NONE
  hi StatusLineNC      ctermfg=7    ctermbg=8    cterm=NONE
  hi TabLine           ctermfg=7    ctermbg=8
  hi TabLineFill       ctermbg=8    ctermfg=NONE
  hi TabLineSel        ctermfg=0    ctermbg=11
  hi VertSplit         ctermfg=8
  hi Visual            ctermbg=8    ctermfg=15   cterm=bold
  hi WarningMsg        ctermfg=11   cterm=bold
  hi Whitespace        ctermfg=8
  hi WildMenu          ctermbg=11   ctermfg=0    cterm=bold
  hi WinSeparator      ctermfg=8    cterm=NONE
  hi diffAdded         ctermfg=10
  hi diffChanged       ctermfg=12
  hi diffRemoved       ctermfg=9

  " LSP Diagnostics
  hi DiagnosticError   ctermfg=1 cterm=undercurl
  hi DiagnosticWarn    ctermfg=3 cterm=undercurl
  hi DiagnosticInfo    ctermfg=4 cterm=undercurl
  hi DiagnosticHint    ctermfg=6 cterm=undercurl

  " Syntax (Minimal - Dark Terminal ANSI)
  hi Comment      ctermfg=8  cterm=italic
  hi Constant     ctermfg=3
  hi Character    ctermfg=3
  hi Number       ctermfg=3
  hi Float        ctermfg=3
  hi Error        ctermfg=1  ctermbg=NONE cterm=bold,undercurl
  hi Function     ctermfg=4
  hi Identifier   ctermfg=15
  hi Keyword      ctermfg=5
  hi Conditional  ctermfg=5
  hi Repeat       ctermfg=5
  hi Statement    ctermfg=5
  hi Operator     ctermfg=6
  hi PreProc      ctermfg=13
  hi Special      ctermfg=13
  hi StorageClass ctermfg=11
  hi String       ctermfg=2
  hi Structure    ctermfg=11
  hi Todo         ctermfg=0  ctermbg=11 cterm=bold
  hi Type         ctermfg=11

else " background ==# 'light'
  " Editor (Minimal - Light Terminal ANSI)
  hi Cursor            ctermbg=0    ctermfg=15
  hi CursorLine        ctermbg=7    ctermfg=NONE
  hi CursorLineNr      ctermfg=4
  hi DiffAdd           ctermbg=2    ctermfg=0
  hi DiffChange        ctermbg=4    ctermfg=0
  hi DiffDelete        ctermbg=1    ctermfg=0
  hi DiffText          ctermbg=6    ctermfg=0
  hi EndOfBuffer       ctermfg=7
  hi ErrorMsg          ctermfg=1    cterm=bold,italic
  hi IncSearch         ctermbg=1    ctermfg=15
  hi LineNr            ctermfg=0
  hi MatchParen        ctermbg=NONE ctermfg=5    cterm=underline,bold
  hi ModeMsg           ctermbg=0    ctermfg=15   cterm=bold
  hi MoreMsg           ctermfg=4
  hi NonText           ctermfg=7
  hi Normal            ctermbg=NONE ctermfg=0
  hi NormalFloat       ctermbg=NONE ctermfg=0
  hi Pmenu             ctermbg=7    ctermfg=0
  hi PmenuSel          ctermbg=8    ctermfg=15   cterm=bold
  hi Search            ctermbg=3    ctermfg=0
  hi SignColumn        ctermfg=0
  hi SpellBad          cterm=undercurl ctermfg=1
  hi StatusLine        ctermfg=0    ctermbg=7    cterm=NONE
  hi StatusLineNC      ctermfg=8    ctermbg=15   cterm=NONE
  hi TabLine           ctermfg=8    ctermbg=15
  hi TabLineFill       ctermbg=15   ctermfg=NONE
  hi TabLineSel        ctermfg=0    ctermbg=3
  hi VertSplit         ctermfg=8
  hi Visual            ctermbg=8    ctermfg=15   cterm=bold
  hi WarningMsg        ctermfg=1    cterm=bold
  hi Whitespace        ctermfg=7
  hi WildMenu          ctermbg=3    ctermfg=0    cterm=bold
  hi WinSeparator      ctermfg=8    cterm=NONE
  hi diffAdded         ctermfg=2
  hi diffChanged       ctermfg=4
  hi diffRemoved       ctermfg=1

  " LSP Diagnostics
  hi DiagnosticError   ctermfg=1 cterm=undercurl
  hi DiagnosticWarn    ctermfg=11 cterm=undercurl " Bright Yellow for better contrast
  hi DiagnosticInfo    ctermfg=4 cterm=undercurl
  hi DiagnosticHint    ctermfg=6 cterm=undercurl

  " Syntax (Minimal - Light Terminal ANSI)
  hi Comment      ctermfg=4  cterm=italic " Blue
  hi Constant     ctermfg=6  " Cyan
  hi Character    ctermfg=6
  hi Number       ctermfg=6
  hi Float        ctermfg=6
  hi Error        ctermfg=1  ctermbg=NONE cterm=bold,undercurl
  hi Function     ctermfg=1  " Red
  hi Identifier   ctermfg=0  " Black
  hi Keyword      ctermfg=5  " Magenta
  hi Conditional  ctermfg=5
  hi Repeat       ctermfg=5
  hi Statement    ctermfg=5
  hi Operator     ctermfg=12 " Bright Blue
  hi PreProc      ctermfg=13 " Bright Magenta
  hi Special      ctermfg=13
  hi StorageClass ctermfg=12 " Bright Blue
  hi String       ctermfg=2  " Green
  hi Structure    ctermfg=12 " Bright Blue
  hi Todo         ctermfg=15 ctermbg=3  cterm=bold " Yellow bg, White fg
  hi Type         ctermfg=12 " Bright Blue
endif
