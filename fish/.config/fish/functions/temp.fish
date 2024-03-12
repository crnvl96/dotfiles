function temp
    set cmd $argv
    set temp_file (mktemp)
    eval $cmd >$temp_file
    nvim $temp_file
end
