# vim: expandtab tabstop=4 shiftwidth=4

# Set up dir colors for ls and zsh tab completion
eval $(dircolors -b)
alias ls="ls -F --color=auto"
alias vi="vim"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias pcregrep="pcregrep --color"
alias ll="ls -la"
alias l="ls"
alias tree="tree -F -C"
alias ipython="ipython --no-confirm-exit"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."
alias ........="cd ../../../../../../.."
alias ssh="~/bin/ssh"
alias scp="~/bin/scp"
alias gst="git status"

# my common usernames...
zstyle ':completion:*:(ssh|scp):*' users besen dbesen sargon ${(k)userdirs}

# ssh hostnames...
local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts

zstyle ':completion:*' verbose yes

# Avoid having to manually run rehash
_force_rehash() {
    (( CURRENT == 1 )) && rehash
    return 1 # Because we didn't really complete anything
}

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _force_rehash _complete _ignored
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' original true
#zstyle :compinstall filename '/home/sargon/.zshrc'

# completion for pip
eval "`pip completion --zsh`"

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob
setopt dotglob
bindkey -v

autoload -U promptinit
promptinit
prompt walters
# For valid color values, run http://www.vim.org/scripts/script.php?script_id=1349
LEFT_COLOR='white'
RIGHT_COLOR='green'
if [ -f ~/.zsh-colors ]; then . ~/.zsh-colors; fi
PS1='%F{$LEFT_COLOR}%n@%m> %f'
setopt prompt_subst
RPROMPT='%F{$RIGHT_COLOR}$(git-rprompt)%~%f'
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
bindkey "^?" backward-delete-char # the default is vi-backward-delete-char, which actually fills the ^y buffer

zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

LISTMAX=200
zstyle ':completion:*:kill:*:processes' command "ps x"
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# Turn off menu completion for kill
zstyle ':completion:*:kill:*:processes' insert-ids single

# Don't vi .class files
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.class' '*.pyc' '*.pyo'

export TZ='America/Denver'

export PATH=$PATH:/home/besen/git-scripts:/home/besen/bin

export PIP_DOWNLOAD_CACHE=~/.pip_download_cache

if [ -e /usr/share/terminfo/x/xterm-256color ] || [ -e /lib/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm'
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

# Workaround for dbus not properly exiting (prevents logout and kills dropbox otherwise)
# sometimes 'service messagebus restart' seems to fix it (centos)
export DBUS_SESSION_BUS_ADDRESS=:0.0

# If dropbox is installed, check if it's running, and start it if not
if [ -e ~/bin/dropbox ]; then
    if dropbox status 2>&1 | grep -q -i "isn't running"
    then
        ~/bin/dropbox start
    fi
fi

# Turn on unicode support
export LANG="en_US.UTF-8"

# Disable ^s scroll locking
stty -ixon -ixoff -ixany
