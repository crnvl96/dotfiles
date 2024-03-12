function lf
    set LFCD (command lf -print-last-dir $argv)
    if test -d "$LFCD"
        cd $LFCD
    end
end
