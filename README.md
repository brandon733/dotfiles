## Dot Files

These are _my_ dot files. Your mileage may vary.

Environments where these scripts have been used: Mac OSX and Linux (Fedora, CentOS,
Ubuntu), Windows WSL.

Bash forever.

Notes:
* I'm using bash5. On OSX, default bash is version 3, see <https://apple.stackexchange.com/a/197172>
    for an explanation of the lameness. Use brew to update to version 5
* Best terminal program on Mac? Terminal.app. It's _fast._ Main problem is that it
    only supports 256 colors, but the speed is worth it.
* Light background. I used a dark background for 20 years and it makes you feel c0013r.
    But a light background (gruvbox8-soft, solarized-light or PaperColor) allows for
    using smaller fonts (SF Mono or JetBrains Mono 10pt on MBP 15.) If you use a
    dark background, you'll probably need to go a point higher.

#### Optional bash command line goodness:

* bash-completion, if you updated to bash v5 on Mac, use bash-completion@2, otherwise v1 works
* autojump
* direnv


#### Install:

```
~$ mkdir -p ~/bin
~$ cd ~/bin && git clone https://github.com/brandon733/dotfiles.git
~$ cd ~/bin/dotfiles
~/bin/dotfiles$ ./update [--vim]
```
