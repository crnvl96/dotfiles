_proto() {
    local i cur prev opts cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd=""
    opts=""

    for i in ${COMP_WORDS[@]}
    do
        case "${cmd},${i}" in
            ",$1")
                cmd="proto"
                ;;
            proto,activate)
                cmd="proto__activate"
                ;;
            proto,alias)
                cmd="proto__alias"
                ;;
            proto,bin)
                cmd="proto__bin"
                ;;
            proto,clean)
                cmd="proto__clean"
                ;;
            proto,completions)
                cmd="proto__completions"
                ;;
            proto,debug)
                cmd="proto__debug"
                ;;
            proto,diagnose)
                cmd="proto__diagnose"
                ;;
            proto,install)
                cmd="proto__install"
                ;;
            proto,list)
                cmd="proto__list"
                ;;
            proto,list-remote)
                cmd="proto__list__remote"
                ;;
            proto,migrate)
                cmd="proto__migrate"
                ;;
            proto,outdated)
                cmd="proto__outdated"
                ;;
            proto,pin)
                cmd="proto__pin"
                ;;
            proto,plugin)
                cmd="proto__plugin"
                ;;
            proto,regen)
                cmd="proto__regen"
                ;;
            proto,run)
                cmd="proto__run"
                ;;
            proto,setup)
                cmd="proto__setup"
                ;;
            proto,status)
                cmd="proto__status"
                ;;
            proto,unalias)
                cmd="proto__unalias"
                ;;
            proto,uninstall)
                cmd="proto__uninstall"
                ;;
            proto,unpin)
                cmd="proto__unpin"
                ;;
            proto,upgrade)
                cmd="proto__upgrade"
                ;;
            proto__debug,config)
                cmd="proto__debug__config"
                ;;
            proto__debug,env)
                cmd="proto__debug__env"
                ;;
            proto__plugin,add)
                cmd="proto__plugin__add"
                ;;
            proto__plugin,info)
                cmd="proto__plugin__info"
                ;;
            proto__plugin,list)
                cmd="proto__plugin__list"
                ;;
            proto__plugin,remove)
                cmd="proto__plugin__remove"
                ;;
            proto__plugin,search)
                cmd="proto__plugin__search"
                ;;
            *)
                ;;
        esac
    done

    case "${cmd}" in
        proto)
            opts="-c -h -V --config-mode --dump --log --help --version activate alias bin clean completions debug diagnose install list list-remote migrate outdated pin plugin regen run setup status unalias uninstall unpin upgrade"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 1 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__activate)
            opts="-c -h -V --export --json --no-bin --no-shim --config-mode --dump --log --help --version [SHELL]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__alias)
            opts="-c -h -V --global --to --config-mode --dump --log --help --version <ID> <ALIAS> <SPEC>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --to)
                    COMPREPLY=($(compgen -W "global local user" -- "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__bin)
            opts="-c -h -V --bin --shim --config-mode --dump --log --help --version <ID> [SPEC]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__clean)
            opts="-c -h -V --days --purge --purge-plugins --yes --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --days)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --purge)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__completions)
            opts="-c -h -V --shell --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --shell)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__debug)
            opts="-c -h -V --config-mode --dump --log --help --version config env"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__debug__config)
            opts="-c -h -V --json --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__debug__env)
            opts="-c -h -V --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__diagnose)
            opts="-c -h -V --shell --json --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --shell)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__install)
            opts="-c -h -V --canary --force --pin --config-mode --dump --log --help --version [ID] [SPEC] [PASSTHROUGH]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --pin)
                    COMPREPLY=($(compgen -W "global local user" -- "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__list)
            opts="-c -h -V --aliases --config-mode --dump --log --help --version <ID>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__list__remote)
            opts="-c -h -V --aliases --config-mode --dump --log --help --version <ID>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__migrate)
            opts="-c -h -V --config-mode --dump --log --help --version <OPERATION>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__outdated)
            opts="-c -h -V --json --latest --update --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__pin)
            opts="-c -h -V --global --resolve --to --config-mode --dump --log --help --version <ID> <SPEC>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --to)
                    COMPREPLY=($(compgen -W "global local user" -- "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__plugin)
            opts="-c -h -V --config-mode --dump --log --help --version add info list remove search"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__plugin__add)
            opts="-c -h -V --global --to --config-mode --dump --log --help --version <ID> <PLUGIN>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --to)
                    COMPREPLY=($(compgen -W "global local user" -- "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__plugin__info)
            opts="-c -h -V --json --config-mode --dump --log --help --version <ID>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__plugin__list)
            opts="-c -h -V --aliases --json --versions --config-mode --dump --log --help --version [IDS]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__plugin__remove)
            opts="-c -h -V --global --from --config-mode --dump --log --help --version <ID>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --from)
                    COMPREPLY=($(compgen -W "global local user" -- "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__plugin__search)
            opts="-c -h -V --json --config-mode --dump --log --help --version <QUERY>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 3 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__regen)
            opts="-c -h -V --bin --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__run)
            opts="-c -h -V --alt --config-mode --dump --log --help --version <ID> [SPEC] [PASSTHROUGH]..."
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --alt)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__setup)
            opts="-y -c -h -V --shell --no-modify-profile --no-modify-path --yes --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --shell)
                    COMPREPLY=($(compgen -f "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__status)
            opts="-c -h -V --json --config-mode --dump --log --help --version"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__unalias)
            opts="-c -h -V --global --from --config-mode --dump --log --help --version <ID> <ALIAS>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --from)
                    COMPREPLY=($(compgen -W "global local user" -- "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__uninstall)
            opts="-c -h -V --yes --config-mode --dump --log --help --version <ID> [SPEC]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__unpin)
            opts="-c -h -V --global --from --config-mode --dump --log --help --version <ID>"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --from)
                    COMPREPLY=($(compgen -W "global local user" -- "${cur}"))
                    return 0
                    ;;
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        proto__upgrade)
            opts="-c -h -V --check --json --config-mode --dump --log --help --version [TARGET]"
            if [[ ${cur} == -* || ${COMP_CWORD} -eq 2 ]] ; then
                COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
                return 0
            fi
            case "${prev}" in
                --config-mode)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                -c)
                    COMPREPLY=($(compgen -W "global local upwards upwards-global" -- "${cur}"))
                    return 0
                    ;;
                --log)
                    COMPREPLY=($(compgen -W "off error warn info debug trace verbose" -- "${cur}"))
                    return 0
                    ;;
                *)
                    COMPREPLY=()
                    ;;
            esac
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
    esac
}

if [[ "${BASH_VERSINFO[0]}" -eq 4 && "${BASH_VERSINFO[1]}" -ge 4 || "${BASH_VERSINFO[0]}" -gt 4 ]]; then
    complete -F _proto -o nosort -o bashdefault -o default proto
else
    complete -F _proto -o bashdefault -o default proto
fi
