vim9script

def MarksDel()
    delm! | delm A-Z0-9a-z
enddef
command MarksDel MarksDel()


def TmuxSplit()
    system('tmux split-window -h -c "' .. expand("%:p:h") .. '"')
enddef
command TmuxSplit TmuxSplit()

def FileCopyPath()
    setreg('+', expand('%:p'))
enddef
command FileCopyPath FileCopyPath()
