vim9script

g:loaded_netrw = 1
g:loaded_netrwPlugin = 1

g:mapleader = "\<Space>"
g:maplocalleader = "\,"

g:popup_borderchars = ['─', '│', '─', '│', '╭', '╮', '╯', '╰']
g:popup_borderchars_t = ['─', '│', '─', '│', '├', '┤', '╯', '╰']

g:hlyank_hlgroup = "Pmenu"
g:hlyank_duration = 250

packadd comment
packadd nohlsearch
packadd hlyank
packadd matchit
packadd editorconfig
