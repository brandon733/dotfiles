# various auto-activate scripts
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

source $(dirname $BASH_SOURCE)/upfind.sh
source $(dirname $BASH_SOURCE)/relpath.sh

# NOTE: this is not compatible w `pipenv shell` but I don't care bc I don't use it
_pipenv_auto_activate() {
    unset msg

    # _PIPENV_ACT_PATH -- this is the path at which pipenv was activated,
    #  if we go above this path, then deactivate
    if [ -d "$_PIPENV_ACT_PATH" ]; then
        _base=$(basename $_PIPENV_ACT_PATH)
        if [[ ! $PWD/ =~ ^$_PIPENV_ACT_PATH/ ]]; then
            msg="Deactivating $VIRTUAL_ENV"
            deactivate
            unset _PIPENV_ACT_PATH
        fi
    fi

    local _f=$(upfind Pipfile.lock)
    if [ -f "$_f" ]; then
        local _env=$(cd $(dirname $_f) && PIPENV_VERBOSITY=-1 pipenv --venv)
        [ -d "$_env" ] && _PIPENV_ACT_PATH=$(dirname $_f)

        # Check to see if already activated to avoid redundant activating
        if [ -n "$_PIPENV_ACT_PATH" ] && [ "$VIRTUAL_ENV" != "$_env" ]; then
            VIRTUAL_ENV_DISABLE_PROMPT=1 # we'll do the prompt ourselveds
            msg="Activating $_env"
            source $_env/bin/activate
        fi
    fi

    unset VENV
    if [ -n "$VIRTUAL_ENV" ] && [ -n "$_PIPENV_ACT_PATH" ]; then
        # Display rel path to pipenv root dir in prompt
        local t="$(basename $_PIPENV_ACT_PATH)"
        local p="$(relpath "$PWD" "$_PIPENV_ACT_PATH")"
        #[ "$p" = "." ] && p="" || p="$p/"
        p="$t" # just use name, use "$t:$p" if entire (rel) path is desired
        VENV="(\[$(tput sitm)\]$p\[$(tput ritm)\]) " # italicize
    fi

    [ "$msg" ] && echo -e "\e[3m\x1B[38;5;248m  $msg\e[0m"
}

_conda_auto_activate() {
    # For conda activate, must add this on every prompt (not just pwd changes)
    # conda can be activated w/o changing dirs (conda [de]activate ..)
    #unset VENV && [ "$CONDA_DEFAULT_ENV" ] && VENV="(${CONDA_DEFAULT_ENV}) "

    # _CONDA_ENV_ACT_PATH -- this is the path at which conda env was activated,
    #  if we go above this path, then deactivate
    if [ -d "$_CONDA_ENV_ACT_PATH" ]; then
        _base=$(basename $_CONDA_ENV_ACT_PATH)
        if [[ ! $PWD/ =~ ^$_CONDA_ENV_ACT_PATH/ ]]; then
            msg="Deactivating $CONDA_DEFAULT_ENV"
            conda deactivate
            unset _CONDA_ENV_ACT_PATH
        fi
    fi

    local _env
    _f=$(upfind .conda.env)
    if [ -f "$_f" ]; then
        read -r _env <"$_f"
    fi
    if [ "$_env" ] && [ "$_env" != "$CONDA_DEFAULT_ENV" ]; then
        conda activate $_env
        _CONDA_ENV_ACT_PATH=$(dirname $_f)
    fi
}

_virtualenv_auto_activate() {
    unset msg
    # Deactivate if venv dir no longer exists OR not prefix of pwd
    if [ "$VIRTUAL_ENV" ]; then
        base=$(basename $VIRTUAL_ENV)
        if [ ! -d "$VIRTUAL_ENV" ] || [[ ! $PWD/ =~ ^$(dirname $VIRTUAL_ENV)/ ]]; then
            msg="Deactivating $VIRTUAL_ENV"
            unset _VENV_PATH
            deactivate
        fi
    fi

    # Check for symlink pointing to virtualenv
    if [ -L ".venv" ]; then
        # could be absolute or relative link, but the pwd is valid since we are in chpwd
        dir=`dirname $(readlink .venv)`
        base=`basename $(readlink .venv)`
        [ "$dir" = "." ] \
            && _VENV_PATH="$(pwd -P)/$base" \
            || _VENV_PATH="$(cd $dir >/dev/null && pwd -P)/$base"

    elif [ -d ".venv" ]; then
        _VENV_PATH=$(pwd -P)/.venv

    else
        _d=$(upfind .venv /)
        [ -n "$_d" ] && _VENV_PATH=$_d
    fi

    # Check to see if already activated to avoid redundant activating
    if [ -n "$_VENV_PATH" ] && [ "$VIRTUAL_ENV" != "$_VENV_PATH" ]; then
        _VENV_NAME=$(basename `pwd`)
        VIRTUAL_ENV_DISABLE_PROMPT=1
        source $_VENV_PATH/bin/activate
        #msg="Activating $VIRTUAL_ENV"
    fi

    unset VENV
    if [ -n "$VIRTUAL_ENV" ]; then
        local _h=$(dirname $VIRTUAL_ENV)
        local _t=$(basename $VIRTUAL_ENV)
        p="$(relpath $PWD $_h)"
        [ "$p" = "" ] && p="."
        [ "$_h" = "$HOME" ] && p="~"
        #VENV="(\[$(tput sitm)\]$p\[$(tput ritm)\]) " # italicize
        VENV="𝓋($p) "
    fi
    [ "$msg" ] && echo -e "\e[3m\x1B[38;5;248m  $msg\e[0m"
}
