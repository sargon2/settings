set nocompatible

" Vundle
" To install: git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
filetype off " will be turned back on later
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle (required!)
Bundle 'gmarik/vundle'

" My bundles here:

Bundle 'bartman/git-wip'
" TODO: checksyntax isn't working for python
Bundle 'tomtom/checksyntax_vim'
Bundle 'desert256.vim'
Bundle 'yaifa.vim'
Bundle 'openssl.vim'
Bundle 'cmdalias.vim'
Bundle 'davidhalter/jedi-vim'

" TODO: tab completion that works right -- like bash/zsh (and shows a menu), and works with python etc

" TODO: automatically run vundle on startup? is it fast enough? surely at least BundleClean is...
" End Vundle

filetype plugin indent on

" jedi config
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#goto_command = "<F3>"

set mouse=a
set hidden
set ruler
set incsearch
set hlsearch
set nobackup
set noswapfile
set showcmd
set timeoutlen=0
set ignorecase
set infercase
set backspace=indent,eol,start
set nowrap

set t_Co=256
colorscheme desert256


syntax on

" TODO: use SuperTab instead of this
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


au BufRead,BufNewFile *.txt set filetype=text

" disable annoying auto-wrap for text files
autocmd FileType text setlocal textwidth=0

autocmd FileType text set wrap

" parse .xhtml as .html
au BufRead,BufNewFile *.xhtml set filetype=html
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

" Change yank to not affect the current cursor position (the default is to
" move it to the start of the selection)
vnoremap y myyg`y

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


"make alt+# swap buffers
nmap <esc>1 :b 1<CR>
nmap <esc>2 :b 2<CR>
nmap <esc>3 :b 3<CR>
nmap <esc>4 :b 4<CR>
nmap <esc>5 :b 5<CR>
nmap <esc>6 :b 6<CR>
nmap <esc>7 :b 7<CR>
nmap <esc>8 :b 8<CR>
nmap <esc>9 :b 9<CR>

"make alt+arrow move lines up or down
nnoremap <esc><down> :m+<CR>
nnoremap <esc><up> :m-2<CR>
inoremap <esc><down> <Esc>:m+<CR>gi
inoremap <esc><up> <Esc>:m-2<CR>gi
vnoremap <esc><down> :m'>+<CR>gv
vnoremap <esc><up> :m-2<CR>gv

"make regular expressions more sane
:nnoremap / /\v
:cnoremap s/ s/\v

autocmd VimEnter * Alias q qa
autocmd VimEnter * Alias wq wqa

set expandtab
set tabstop=4
set shiftwidth=4

set encoding=utf-8
setglobal fileencoding=utf-8
"setglobal bomb " byte order marks aren't actually used
set fileencodings=utf-8,latin1

if filereadable("/usr/share/vim/plugin/ropevim.vim")
    source /usr/share/vim/plugin/ropevim.vim
endif

"make vimdiff more readable
:highlight! link DiffChange Normal
:highlight! link DiffText CursorLine
:highlight! link DiffAdd TabLine
:highlight! link DiffDelete Ignore

"make omnicompletion more readable
:highlight Pmenu ctermbg=238 gui=bold

" Remove whitespace at the end of lines for some file types
autocmd BufWritePre *.cpp,*.c,*.hpp,*.h,*.java,*.py %s/\s\+$//ge

set foldlevelstart=99
