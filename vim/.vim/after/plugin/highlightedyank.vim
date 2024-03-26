vim9script

if exists("g:loaded_highlightedyank")
    hi HighlightedyankRegion cterm=reverse gui=reverse
    g:highlightedyank_highlight_duration = 300
    g:highlightedyank_highlight_in_visual = 0
endif
