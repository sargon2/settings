#!/usr/bin/zsh

# http://hints.macworld.com/article.php?story=20050806202859392
set -A tdirs ${(f)"$(dirs -pl)"} # Current directory stack
if [ -e ~/.zdirs ]; then
    set -A zdirs ${(f)"$(<~/.zdirs)"} # Saved stack
    # Find matching list tails
    for i in {1..$#zdirs}; do
        [ \! -z ${(M)${(F)tdirs}%${(F)zdirs[$i,-1]}} ] && {
            (( tail_length=$#zdirs-$i+1 )); # This length tail matches
            break; 
        }
    done 
    # Trim the matched tail off tdirs
    set -A tdirs $tdirs[1,-(( $tail_length+1 ))] $zdirs
fi

print -l ${(u)tdirs} >! ~/.zdirs
