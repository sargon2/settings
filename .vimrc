set nocompatible

" Vundle
if !isdirectory(expand("~/.vim/bundle/vundle"))
    silent !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    let s:setupvundle=1
endif

filetype off " will be turned back on later
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/vundle'

" My plugins
Plugin 'sargon2/git-wip'
" Syntastic seems to hang when I :w java files
" Plugin 'scrooloose/syntastic'
Plugin 'desert256.vim'
Plugin 'Raimondi/YAIFA'
Plugin 'openssl.vim'
Plugin 'cmdalias.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'VOoM'
Plugin 'elzr/vim-json'
" Plugin 'klen/python-mode'

" TODO: automatically run vundle on startup? is it fast enough? surely at least BundleClean is...

call vundle#end()
filetype plugin indent on
if exists('s:setupvundle') && s:setupvundle
    unlet s:setupvundle
    PluginInstall
    quitall
endif

let g:vim_json_syntax_conceal = 0 " don't conceal quotes in json highlighting

" jedi config

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#goto_assignments_command = "<F3>"


" pymode config

" let g:pymode_rope_organize_imports_bind = '<C-c>ro'
" let g:pymode_rope_autoimport_bind = '<C-c>ra'  " Should be enabled 'g:pymode_rope_autoimport'
" let g:pymode_rope_module_to_package_bind = '<C-c>r1p'
" let g:pymode_rope_use_function_bind = '<C-c>ru'
" let g:pymode_rope_move_bind = '<C-c>rv'
" let g:pymode_rope_change_signature_bind = '<C-c>rs'


let g:pymode_options = 0 " Turn off 79-col max, etc
let g:pymode_lint = 0
let g:pymode_lint_write = 0
let g:pymode_rope = 1
let g:pymode_rope_rename_bind = '<F2>'
" let g:pymode_rope_rename_module_bind = '<F2>'
let g:pymode_rope_goto_definition_bind = '<F3>'
let g:pymode_rope_goto_definition_cmd = 'new' " e, new, vnew
let g:pymode_rope_extract_method_bind = '<F4>'
let g:pymode_rope_extract_variable_bind = '<F5>'

" invoke git-wip
so ~/.vim/bundle/git-wip/vim/plugin/git-wip.vim


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
set scrolloff=5

" Make tab completion for files work like bash (for :e etc)
set nowildmenu
set wildmode=longest,list

set t_Co=256
colorscheme desert256


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

" highlight trailing whitespace (from http://vim.wikia.com/wiki/Highlight_unwanted_spaces)
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" color for line numbers
highlight LineNr ctermfg=darkgrey


au BufRead,BufNewFile *.txt set filetype=text

" disable annoying auto-wrap for text files
autocmd FileType text setlocal textwidth=0

autocmd FileType text set wrap

" parse .xhtml as .html
au BufRead,BufNewFile *.xhtml set filetype=html
au BufRead,BufNewFile *.xhtml set indentexpr=

autocmd BufRead,BufNewFile *.as set filetype=actionscript
autocmd BufRead,BufNewFile *.mxml set filetype=mxml

" inform 7
autocmd BufRead,BufNewFile *.ni set filetype=inform7
autocmd FileType inform7 set wrap
autocmd FileType inform7 set nu

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

" If you select lines, then paste over them, it shouldn't copy what you replaced.
vnoremap p "0p

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


"save undo if we qa!
function! MyWundoQuit()
    let undoseq = undotree().seq_cur
    earlier 1f
    let undof = escape(undofile(expand('%')),'% ')
    exec "wundo " . undof
    silent! exec "u " . undoseq
endfunction

autocmd BufWinLeave * call MyWundoQuit()


"make ctrl-d quit, and save undo
map <c-d> <ESC>:qa!<CR>
map! <c-d> <ESC>:qa!<CR>

"make regular expressions more sane
nnoremap / /\v
" TODO: make this work for :%s/.../.../g -- it doesn't work because timeout is set to zero
cnoremap s/ s/\v

"make :W save with sudo (kind of, doesn't mark the file as written)
command W w !sudo tee % > /dev/null

autocmd VimEnter * Alias q qa
autocmd VimEnter * Alias wq wqa

set expandtab
set tabstop=4
set shiftwidth=4

set encoding=utf-8
setglobal fileencoding=utf-8
"setglobal bomb " byte order marks aren't actually used
set fileencodings=utf-8,latin1

" pip install ropevim
if filereadable("/usr/local/share/vim/plugin/ropevim.vim")
    source /usr/local/share/vim/plugin/ropevim.vim
endif

"make vimdiff more readable
:highlight! link DiffChange Normal
:highlight! link DiffText CursorLine
:highlight! link DiffAdd TabLine
:highlight! link DiffDelete Ignore
" TODO: make vimdiff not fold things by default

"make omnicompletion more readable
:highlight Pmenu ctermbg=238 gui=bold

" Remove whitespace at the end of lines for some file types
autocmd BufWritePre *.cpp,*.c,*.hpp,*.h,*.java,*.py %s/\s\+$//ge

set foldlevelstart=99

" Change the way folding works for plain text files
function! MyFoldLevel(lnum)
    " There are N cases:
    " Line 1 <-- fold starts
    "   Line 2
    "
    " Line 1 <-- no fold starts
    " Line 2
    "
    "   Line 1 <-- fold ends
    " Line 2
    "
    "     Line 1 <-- 2 folds end
    " Line 2
    if getline(a:lnum) =~ '^\s*$'
        return -1 " should this be '='?
    endif
    let ind = (indent(a:lnum)/&shiftwidth)
    let next_ind = (indent(a:lnum+1)/&shiftwidth)
    " let prev_ind = (indent(a:lnum-1)/&shiftwidth)
    if ind < next_ind
        return '>'.next_ind
    endif
    return ind
endfunction
autocmd FileType text setlocal foldmethod=expr
autocmd FileType text setlocal foldexpr=MyFoldLevel(v:lnum)
autocmd FileType text set foldtext=getline(v:foldstart)
autocmd FileType text set fillchars=fold:\ "(there's a space after that \)

" We can't do this with a normal set because it gets overridden by filetype
" plugins
autocmd FileType * setlocal formatoptions=tcqnj

" Persistent undo
silent !mkdir -p ~/.vim/undodir >/dev/null 2>&1
set undodir=~/.vim/undodir
set undofile

" allow the cursor off the end of the line to the right
set virtualedit=all

" Don't move the cursor left one when existing insert mode
" http://vim.wikia.com/wiki/Prevent_escape_from_moving_the_cursor_one_character_to_the_left
let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

