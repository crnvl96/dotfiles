function lf_cd
    set LFCD (command lf -print-last-dir $argv)
    if test -d "$LFCD"
        cd $LFCD
    end
end


function lf
    set path
    set clipboard_content (fish_clipboard_paste)

    if test -n "$clipboard_content"
        set path $clipboard_content
    else
        set path $argv
    end

    set LFCD (command lf -print-last-dir $path)

    if test -d "$LFCD"
        cd $LFCD
    else
        lf_cd
    end
end
