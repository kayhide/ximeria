source "prelude.bash"

optparse.parse() {
    local content
    read -r -d '' content
    local spec_opts=$(yq eval ".opts[]" <(echo "$content") 2>/dev/null)
    local spec_args=$(yq eval ".args[]" <(echo "$content") 2>/dev/null)

    while (( 0 < ${#} )); do
        if [[ $1 =~ --(.*) ]]; then
            local key="${BASH_REMATCH[1]}"
            if ! echo "$spec_opts" | grep "^$key\$" >/dev/null 2>&1; then
                die "invalid option: $key"
            fi
            if [[ -n ${2:-} ]] && [[ ! $2 =~ -- ]]; then
                echo "$key='$2'"
                shift 2
            elif [[ -n $key ]]; then
                echo "$key="
                shift
            fi
        else
            break
        fi
    done

    for x in $spec_args; do
        if [[ $x =~ ^\.\.\.([^\.]+) ]]; then
            local key="${BASH_REMATCH[1]}"
            printf "%s=(%s)\n" "${key,,}" "$*"
            break
        elif (( 0 < ${#} )); then
            local arg="$1"
            local t=$(yq eval ".types.$x[]" <(echo "$content") 2>/dev/null)
            if [[ -n $t ]]; then
                if ! echo "$t" | grep -q "^$arg\$"; then
                    die "invalid ${x,,}: $arg"
                fi
                echo "${x,,}=$arg"
            else
                echo "${x,,}=$arg"
            fi
        fi
        shift
    done
}

optparse.display_usage() {
    local content
    read -r -d '' content

    local program=$(yq eval ".program" <(echo "$content") 2>/dev/null)
    local opts=$(yq eval ".opts[]" <(echo "$content") 2>/dev/null)
    local -a args=$(yq eval ".args[]" <(echo "$content") 2>/dev/null)
    echo -n "Usage:"
    [[ -n $program ]] && echo -n " $program"
    [[ -n $opts ]] && echo -n " [OPTIONS]"
    for arg in $args; do
        echo -n " $arg"
    done
    echo

    if [[ -n ${opts[@]} ]]; then
        echo
        echo "Available options:"
        for x in $opts; do
            echo "  --$x"
        done
    fi

    for arg in $args; do
        local t=$(yq eval ".types.$arg[]" <(echo "$content") 2>/dev/null)
        if [[ -n $t ]]; then
            echo
            echo "Available ${arg,,}:"
            for x in $t; do
                echo "  $x"
            done
        fi
    done
    echo
}
