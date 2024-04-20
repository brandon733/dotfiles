scriptencoding utf-8
set encoding=utf-8
source ~/.vim/vimrc

" https://stackoverflow.com/a/16135425
" :%s/[[:cntrl:]]//g
" :%s/[^[:print:]]//g

" read ~/.vimrc_local, localvimrc plugin uses `.vimrc.local`
if filereadable(expand('~/.vimrc_local'))
	source ~/.vimrc_local
endif
