# vim: expandtab tabstop=4 shiftwidth=4

# Set up dir colors for ls and zsh tab completion
eval $(dircolors -b)
alias ls="ls -F --color=auto"
alias vi="vim"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias ll="ls -la"
alias l="ls"
alias tree="tree -F -C"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."

# my common usernames...
zstyle ':completion:*:(ssh|scp):*' users besen dbesen sargon ${(k)userdirs}

# ssh hostnames...
local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts

zstyle ':completion:*' verbose yes


# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' original true
zstyle :compinstall filename '/home/sargon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
#

autoload -U promptinit
promptinit
prompt walters
PS1='%n@%m> '
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
case $TERM in (xterm*)
	bindkey '\e[H' beginning-of-line
	bindkey '\e[F' end-of-line ;;
esac
bindkey OH beginning-of-line
bindkey OF end-of-line
bindkey '[5~' up-line-or-history
bindkey '[6~' down-line-or-history
bindkey '\e[3~' delete-char
unsetopt automenu
unsetopt menucomplete
setopt listpacked
setopt nohup
setopt notify
setopt completeinword
setopt autocd
setopt interactivecomments
unsetopt bashautolist
setopt autolist
unsetopt listambiguous
setopt autoparamslash
unsetopt nomatch
unsetopt nullglob
setopt incappendhistory

bindkey "^R" history-incremental-search-backward
bindkey "^U" backward-kill-line
bindkey "^Y" yank

zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

LISTMAX=200
zstyle ':completion:*:kill:*:processes' command "ps x"
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# Turn off menu completion for kill
zstyle ':completion:*:kill:*:processes' insert-ids single

# Don't vi .class files
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.class' '*.pyc' '*.pyo'

export TZ='America/Denver'

export PATH=$PATH:/home/besen/git-scripts

export PIP_DOWNLOAD_CACHE=~/.pip_download_cache

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi

function title() {
    # escape '%' chars in $1, make nonprintables visible
    local a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")

    case $TERM in
        screen*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            print -Pn "\ek$a\e\\"      # screen title (in ^A")
            print -Pn "\e_$2   \e\\"   # screen location
            ;;
        xterm*)
            print -Pn "\e]2;$a @ $2\a" # plain xterm title
            ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd() {
    title "zsh" "%m:%55<...<%~"
}

# preexec is called just before any command line is executed
function preexec() {
    title "$1" "%m:%35<...<%~"
}

# If dropbox is installed, show its status
if [ -e ~/dropbox.py ]; then
    echo
    echo -n "Dropbox status: "
    ~/dropbox.py status
fi

