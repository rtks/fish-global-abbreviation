function __gabbr_expand

    if test "(string trim (commandline -b))" = ''
        return
    end

    set -l token (commandline -t)

    # expand abbreviations
    if test 0 = (count (commandline -poc))
        for abbr in $fish_user_abbreviations
            set -l word   (string split -m1 ' ' $abbr)[1]
            set -l phrase (string split -m1 ' ' $abbr)[2]
            if test "$word" = "$token"
                commandline -t $phrase
            end
        end
    end

    # expand global abbreviations
    for abbr in $global_abbreviations
        set -l word   (string split -m1 ' ' $abbr)[1]
        set -l phrase (string split -m1 ' ' $abbr)[2]
        if string match -q -- "*.$word" "$token"
            if string match -q -- '-x *' $phrase
                set -l file (commandline -t)
                if test 0 = (count (commandline -poc))
                    set -l cmd (string sub -s 4 -- $phrase)
                    commandline -t "$cmd $file"
                end
            end
        else if test "$word" = "$token"
            if string match -q -- '-x *' $phrase
                # do nothing
            else if string match -q -- '-f *' $phrase
                # --function option
                set -l cmd (string sub -s 4 -- $phrase)
                eval $cmd ^/dev/null | string join ' ' | read -l buf
                and commandline -t $buf
            else
                commandline -t $phrase
            end
        end
    end

end

