
augroup IndentFinder
    au! IndentFinder
    au BufRead *.* let b:indent_finder_result = system('python ~/.vim/plugin/indent_finder.py --vim-output "' . expand('%') . '"' )
    au BufRead *.* execute b:indent_finder_result
augroup End

