# $1 is filename, echoes it going up dirs until $HOME but not including $HOME
upfind() {
    dir=`pwd`
    while [[ $dir =~ ^$HOME/ ]]; do
        p=`find "$dir" -maxdepth 1 -name $1`
        if [ ! -z $p ]; then
            echo "$p"
            return
        fi
        dir=`dirname "$dir"`
    done
}
