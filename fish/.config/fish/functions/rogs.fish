function rogs
    for file in (git status --porcelain | awk '{print $2}')
        if test -f $file
            $argv $file
        end
    end
end
