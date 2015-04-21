# vim: expandtab tabstop=4 shiftwidth=4

# Set up dir colors for ls and zsh tab completion
eval $(dircolors -b)
alias ls="ls -F --color=auto"
alias vi="vim"
alias grep="grep --color=auto --exclude-dir=*.git"
alias egrep="egrep --color=auto --exclude-dir=*.git"
alias fgrep="fgrep --color=auto --exclude-dir=*.git"
alias pcregrep="pcregrep --color --exclude-dir=.git"
alias ll="ls -la"
alias l="ls"
alias tree="tree -F -C"
alias ipython="ipython --no-confirm-exit"
alias ssh="~/bin/ssh"
alias scp="~/bin/scp"
alias gst="git status"
alias gb="git branch -vv"
alias gba="git branch -vv -a"
alias gethist="fc -RI"

# my common usernames...
zstyle ':completion:*:(ssh|scp):*' users besen dbesen sargon ${(k)userdirs}

# ssh hostnames...
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

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


# Pip completion should be just this...
#if [[ -x $(which pip) ]]; then
#    eval "`pip completion --zsh`"
#fi

# But, inlining it is 200ms faster.
# pip zsh completion start
function _pip_completion {
    local words cword
    read -Ac words
    read -cn cword
    reply=( $( COMP_WORDS="$words[*]" \
        COMP_CWORD=$(( cword-1 )) \
        PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip
# pip zsh completion end


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
PS1='%F{$LEFT_COLOR}%n@%m%(!.#.>) %f'
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
setopt autopushd pushdignoredups pushdtohome

bindkey "^R" history-incremental-search-backward

function my-backward-kill-line() {
    # If there is text to the left of the cursor
    if [ -n "$LBUFFER" ]; then
        zle backward-kill-line
    else
        CUTBUFFER=
    fi
    # Always clear the kill ring (talk about a security hole!)
    killring=
}
zle -N my-backward-kill-line
bindkey "^U" my-backward-kill-line

bindkey "^Y" yank
bindkey "^?" backward-delete-char # the default is vi-backward-delete-char, which actually fills the ^y buffer

# Get args from previous commands with alt-. and alt-m
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey '\em' copy-earlier-word
bindkey '\e.' insert-last-word

zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

LISTMAX=200
zstyle ':completion:*:kill:*:processes' command "ps x"
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

# Turn off menu completion for kill
zstyle ':completion:*:kill:*:processes' insert-ids single

# Don't vi .class files
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.class' '*.pyc' '*.pyo'

export TZ='America/Denver'

export PATH=$PATH:~/git-scripts:~/bin

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
        DISPLAY_SAVE=$DISPLAY
        unset DISPLAY
        ~/bin/dropbox start
        DISPLAY=$DISPLAY_SAVE
    fi
fi

# Turn on unicode support
export LANG="en_US.UTF-8"

# Disable ^s scroll locking
stty -ixon -ixoff -ixany

# Make ^r work even in the middle of a line
autoload -Uz narrow-to-region
function _history-incremental-preserving-pattern-search-backward
{
    local state
    MARK=CURSOR  # magick, else multiple ^R don't work
    narrow-to-region -p "$LBUFFER${BUFFER:+>>}" -P "${BUFFER:+<<}$RBUFFER" -S state
    zle end-of-history
    zle history-incremental-pattern-search-backward
    narrow-to-region -R state
}
zle -N _history-incremental-preserving-pattern-search-backward
bindkey "^R" _history-incremental-preserving-pattern-search-backward
bindkey -M isearch "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

# Make ^A and ^X increase and decrease the nearest number
_increase_number() {
    local -a match mbegin mend
    [[ $LBUFFER =~ '(-?[0-9]+)[^0-9]*$' ]] &&
    LBUFFER[mbegin,mend]=$(printf %0${#match[1]}d $((10#$match + ${NUMERIC:-1})))
}
_decrease_number() {
    local -a match mbegin mend
    [[ $LBUFFER =~ '(-?[0-9]+)[^0-9]*$' ]] &&
    LBUFFER[mbegin,mend]=$(printf %0${#match[1]}d $((10#$match - ${NUMERIC:-1})))
}
zle -N increase-number _increase_number
zle -N decrease-number _decrease_number
bindkey '^A' increase-number
bindkey '^X' decrease-number

# interactive move
imv() {
    local src dst
    for src; do
        [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
        dst=$src
        vared dst
        [[ $src != $dst ]] && mkdir -p $dst:h && mv -n $src $dst
    done
}

# Print logged-in-from ip
echo -n "You are: "
who -m
