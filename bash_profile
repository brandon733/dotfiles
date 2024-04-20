# See /usr/share/doc/bash/examples/startup-files for examples.
# The files are located in the bash-doc package.

# The default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

[ -x "/opt/homebrew/bin/brew" ] && eval $(/opt/homebrew/bin/brew shellenv)
[ -x "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"

[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin${PATH:+:$PATH}"
[ -d "$HOME/bin" ] && PATH="$HOME/bin${PATH:+:$PATH}"

export PATH

[ -r $HOME/.bash/profile ] && . $HOME/.bash/profile
[ -r $HOME/.bashrc ] && . $HOME/.bashrc

export EDITOR=vim
