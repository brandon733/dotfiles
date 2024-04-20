## set JAVA_HOME to version if it exists
java_set_home() {
    local vers=$1
    if [ "$(uname -s)" = "Darwin" ]; then
        [[ "$vers" != "1.8.0" ]] && vers="-$vers"
        local dir=`ls -dt /Library/Java/JavaVirtualMachines/jdk${vers}* | head -1`
        dir=${dir}/Contents/Home
        [ -d "$dir" ] && JAVA_HOME=$dir
    elif [ "$(uname -s)" = "Linux" ]; then
        local dir="/usr/lib/jvm/java-${vers}-openjdk"
        [ -d "$dir" ] && JAVA_HOME=$dir
    fi
    if [[ -d $JAVA_HOME ]]; then
        msg="JAVA_HOME=${JAVA_HOME}"
        export JAVA_HOME
    else
        unset JAVA_HOME
        echo "Error: JAVA_HOME could not be set"
    fi
}

