
# Set up dir colors for ls and zsh tab completion
eval $(dircolors -b)
alias ls="ls -F --color=auto"
alias vi="vim"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# my common usernames...
zstyle ':completion:*:(ssh|scp):*' users besen dbesen sargon ${(k)userdirs}

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
HISTSIZE=1000
SAVEHIST=1000
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
bindkey "^R" history-incremental-search-backward
bindkey "^U" backward-kill-line
bindkey "^Y" yank

zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

LISTMAX=200
zstyle ':completion:*:kill:*:processes' command "ps x"
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# Turn off menu completion for kill
zstyle ':completion:*:kill:*:processes' insert-ids single

# Don't vi .class files
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.class'

export TZ='America/Denver'
