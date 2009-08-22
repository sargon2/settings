set nocompatible
set mouse=a
set hidden
set ruler
set incsearch
set hlsearch
set nobackup
set showcmd
set timeoutlen=0
set ignorecase
set backspace=indent,eol,start

colorscheme darkblue

syntax on

" If we're in the middle of a word, tab-complete it, otherwise insert a tab
function! CleverTab()
"   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
   let col = col('.') - 1
   if !col || getline('.')[col - 1] !~ '\S'
      return "\<Tab>"
   else
      return "\<C-X>\<C-O>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

set completeopt=longest,menuone

filetype plugin on

" disable annoying auto-wrap for text files
autocmd FileType text setlocal textwidth=0

" parse .xhtml as .html
au BufRead,BufNewFile *.xhtml set filetype=html
au BufRead,BufNewFile *.xhtml filetype indent off
au BufRead,BufNewFile *.xhtml set indentexpr=

autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd BufRead,BufNewFile *.mxml set filetype=mxml

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

autocmd FileType php set keywordprg=~/.vim/php_doc
autocmd FileType java setlocal omnifunc=javacomplete#Complete
"set ww=b,s,h,l,<,>,[,]

" Change yank to not affect the current cursor position (the default is to
" move it to the start of the selection)
vnoremap y myyg`y

"these break omni-completion
"map <Up> gk
"imap <Up> <C-o>gk
"map <Down> gj
"imap <Down> <C-o>gj
set linebreak

au BufEnter * call MyLastWindow()

function! MyLastWindow()
	" if the window is quickfix go on
	if &buftype=="quickfix"
		" if this window is last on screen quit without warning
		if winbufnr(2) == -1
			quit!
		endif
	endif
endfunction

map <s-down> j
map <s-up> k

if &omnifunc == ""
	set omnifunc=syntaxcomplete#Complete
endif

