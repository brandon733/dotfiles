# $1 is filename, echoes it going up dirs until $HOME but not including $HOME
# $2 is optional and is the top level to stop at, defaults to "$HOME/"
upfind() {
    dir=$PWD
    top=${2:-$HOME/}
    while [[ $dir =~ ^${top} ]]; do
        p=$(find "$dir" -maxdepth 1 -name "$1")
        if [ -n "$p" ]; then
            echo "$p"
            return
        fi
        dir=$(dirname "$dir")
    done
}
