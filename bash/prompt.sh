# based on https://gist.github.com/robbles/2211471
# ⓥ ⎇ ⑂ ǂ ‧ ● ⦿ ‣ § 🗲 ⚡ Ϟ ϟ ↯ ✔ ✘ ✖ ★ Ξ ≈ ⁖ 𝑣 ↵

_pwdtail() { #returns the last 2 fields of the working directory
    pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

. $(dirname $BASH_SOURCE[0])/auto_activate.sh

# https://gist.github.com/laggardkernel/6cb4e1664574212b125fbfd115fe90a4
_chpwd_hook() {
    local cmd
    # run commands in CHPWD_COMMAND variable on dir change
    if [ "$PREVPWD" != "$PWD" ]; then
        local IFS=$';'
        for cmd in $CHPWD_COMMAND; do
            "$cmd"
        done
        unset IFS
    fi
    # refresh last working dir record
    export PREVPWD="$PWD"
}

_prompt_setup() {
    local GRAY="\[\033[0;m\]"
    local GRAY_BOLD="\[\033[1;m\]"
    local BLACK="\[\033[0;30m\]"
    local BLACK_BOLD="\[\033[1;30m\]"
    local RED="\[\033[0;31m\]"
    local RED_BOLD="\[\033[1;31m\]"
    local GREEN="\[\033[0;32m\]"
    local GREEN_BOLD="\[\033[1;32m\]"
    local YELLOW="\[\033[0;33m\]"
    local YELLOW_BOLD="\[\033[1;33m\]"
    local BLUE="\[\033[0;34m\]"
    local BLUE_BOLD="\[\033[1;34m\]"
    local PURPLE="\[\033[0;35m\]"
    local PURPLE_BOLD="\[\033[1;35m\]"
    local CYAN="\[\033[0;36m\]"
    local CYAN_BOLD="\[\033[1;36m\]"
    local WHITE="\[\033[0;37m\]"
    local WHITE_BOLD="\[\033[1;37m\]"

    # return color to Terminal setting for text color
    local DEFAULT="\[\033[0;39m\]"
    local BRIGHT="\[\033[38;5;206m\]"

    dots='●●●'

    # https://blog.backslasher.net/git-prompt-variables.html
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT=
    if [ "$(type -t __git_ps1)" ]; then
        GIT="\$(__git_ps1 '↯\[$(tput sitm)\](%s)\[$(tput ritm)\] ')"
    fi

    JOBS="\$([ \j -gt 0 ] && echo [\j])"

    local u=''
    IDENT=
    # SESSION_TYPE is set in .bashrc
    if [ "$SESSION_TYPE" == "remote/ssh" ]; then
        IDENT='[\u@\h] '
        dots="${CYAN}${dots}"

        u="${USER}@"
    fi

    export PS1="${RED}${ERR}${BRIGHT}${dots} \
${CYAN}${IDENT}${BLUE_BOLD}${GIT}${CYAN}\${VENV}\
${YELLOW}\w${CYAN_BOLD}${JOBS}${DEFAULT}\$ "
}
_prompt_setup

_prompt_command() {
    # must be at top
    local code="$?"

    # ALL pwd change functions in this block (good for slower commands)
    if [ "$PREVPWD" != "$PWD" ]; then
        # see auto_activate.sh script for various virtualenv scripts
        _virtualenv_auto_activate # (un)sets VENV
    fi

    # title bar, set to the last field of pwd
    local d=$(dirs +0)
    echo -ne "\033]0;[$(hostname -s)] ${d##*/}\007"

    # print errorcode if not 0, use echo -n if you don't want a newline
    if [ $code -ne 0 ]; then
        echo -e "\033[0;31m${code}↵\033[0;39m"
    fi

    # bash stores history in mem and writes it at exit but we want shared history b/ all shells:
    # -a Append the 'new' history lines to the history file. These are history lines entered since
    #    the beginning of the current bash session, but not already appended to the history file.
    # -c Clear the history list by deleting all the entries.
    # -r Read the contents of the history file and append them to the current history list.
    history -a
    history -c
    history -r
}

# either: 1) if [ "$PREVPWD" != "$PWD" ]; then .. (in _prompt_command)
#     or: 2) append the command into CHPWD_COMMAND, see _chpwd_hook() above
#CHPWD_COMMAND="${CHPWD_COMMAND:+$CHPWD_COMMAND;}_some_bash_fn"

PROMPT_COMMAND="_prompt_command; _chpwd_hook"

## -----
# History (after setting bash prompt)
# See bash(1) for more options
# See https://stackoverflow.com/a/19533853
export HISTFILESIZE=
export HISTSIZE=
HISTTIMEFORMAT="%F %T "
# Change the file location because certain bash sessions truncate .bash_history file upon close:
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_history
export HISTCONTROL=ignorespace:ignoredups:erasedups
shopt -s histappend
# multiline commands: https://askubuntu.com/a/1210371, note 1st line in histfile must begin with `#`
shopt -s cmdhist
shopt -s lithist
