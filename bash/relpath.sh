# do: relpath "$@"
# https://stackoverflow.com/questions/2564634/convert-absolute-path-into-relative-path-given-a-current-directory-using-bash/12498485#12498485
relpath() {
    # both $1 and $2 are absolute paths beginning with /
    # returns relative path to $2/$target from $1/$source
    local source=$1
    local target=$2

    local common_part=$source # for now
    local result="" # for now

    while [[ "${target#$common_part}" == "${target}" ]]; do
        # no match, means that candidate common part is not correct
        # go up one level (reduce common part)
        common_part=$(dirname "$common_part")
        # and record that we went back, with correct / handling
        if [ "$common_part" = "/" ] || [ "$common_part" = "." ]; then
            break # error, are not related dirs
        fi
        [ -z "$result" ] && result=".." || result="../$result"
    done

    if [ "$common_part" == "/" ] || [ "$common_part" == "." ]; then
        # special case for root (no common path)
        result="$result/"
    fi

    # since we now have identified the common part,
    # compute the non-common part
    forward_part="${target#$common_part}"

    # and now stick all parts together
    if [[ -n $result ]] && [[ -n $forward_part ]]; then
        result="$result$forward_part"
    elif [[ -n $forward_part ]]; then
        # extra slash removal
        result="${forward_part:1}"
    fi

    echo $result
}
_relpathX() {
    # path from $1 to $2
    [ $# -ge 1 ] && [ $# -le 2 ] || return 1
    local current="${2:+"$1"}"
    local target="${2:-"$1"}"
    [ "$target" != . ] || target=/
    target="/${target##/}"
    [ "$current" != . ] || current=/
    current="${current:="/"}"
    current="/${current##/}"
    local appendix="${target##/}"
    local relative=''
    while appendix="${target#"$current"/}"
        [ "$current" != '/' ] && [ "$appendix" = "$target" ]; do
        if [ "$current" = "$appendix" ]; then
            relative="${relative:-.}"
            echo "${relative#/}"
            return 0
        fi
        current="${current%/*}"
        relative="$relative${relative:+/}.."
    done
    relative="$relative${relative:+${appendix:+/}}${appendix#/}"
    echo "$relative"
}

# uses python, which starts up the python interpreter (slow)
_relpath0() {
    # opposite param order as relpath, ie path from $2 to $1
    python -c 'import os.path, sys; print(os.path.relpath(sys.argv[1],sys.argv[2]))' "$1" "${2-$PWD}"
}
