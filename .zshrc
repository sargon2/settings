# vim: expandtab tabstop=4 shiftwidth=4

if [[ "$OSTYPE" == "darwin"* ]]; then
    # mac
    alias ls="ls -G"
    alias vi="/usr/local/bin/vim"
    alias vim="/usr/local/bin/vim"
    alias start=open
    alias grep="/usr/local/bin/ggrep --color=auto --exclude-dir=*.git"
else
    # These commands don't work on mac.
    # Set up dir colors for ls and zsh tab completion
    eval $(dircolors -b)
    alias ls="ls -F --color=auto"
    alias vi="vim"
    alias grep="grep --color=auto --exclude-dir=*.git"
fi


alias egrep="egrep --color=auto --exclude-dir=*.git"
alias fgrep="fgrep --color=auto --exclude-dir=*.git"
alias pcregrep="pcregrep --color --exclude-dir=.git"
alias ll="ls -la"
alias l="ls"
alias tree="tree -F -C"
alias ipython="ipython --no-confirm-exit"
#alias scp="~/bin/scp"
alias gst="git status"
alias gb="git branch -vv"
alias gba="git branch -vv -a"
alias gethist="fc -RI"
alias less="less -R"
alias cat="cat -v"
alias trim="sed 's/^[ \t]*//;s/[ \t]*$//'"
alias cls="clear"

# Mac ssh is broken over the vpn, so brew install openssh
# alias ssh="/usr/local/bin/ssh"
# alias scp="/usr/local/bin/scp"
# export GIT_SSH_COMMAND=/usr/local/bin/ssh

# alias git="/usr/local/bin/git"

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
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'l:|=* r:|=*'
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

autoload bashcompinit
bashcompinit
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

function git_rprompt() {
    # TODO: git status is too slow in large repos
    # TODO: show more useful information.  What else?
    # TODO: more color?

    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n "["
        gst=`git status 2>/dev/null`
        if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
            git rev-parse --abbrev-ref HEAD | tr -d '\n'
        else
            # New repository with no commits
            echo -n "HEAD"
        fi
        num=`grep ahead <<< "$gst" | grep -o 'by [0-9]\+' | awk '{print $2}'`
        if [ ! -z "$num" ] && [ "$num" -gt "0" ]; then
            echo -n "+$num"
        fi
        num=`grep behind <<< "$gst" | grep -o 'by [0-9]\+' | awk '{print $2}'`
        if [ ! -z "$num" ] && [ "$num" -gt "0" ]; then
            echo -n "-$num"
        fi
        a=`grep different <<< "$gst"`
        rc=$?
        if [[ $rc == 0 ]] ; then
            echo -n "?"
        fi
        a=`egrep "Changed but not updated|Changes to be committed|Untracked files|Changes not staged for commit" <<< "$gst"`
        rc=$?
        if [[ $rc == 0 ]] ; then
            echo -n "*"
        fi
        echo -n "] "
    fi
}

PS1='%F{$LEFT_COLOR}%n@%m%(!.#.>) %f'
setopt prompt_subst
setopt PROMPT_SP # Show output when there's no newline
RPROMPT='%F{$RIGHT_COLOR}$(git_rprompt)%~%f'
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

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

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
zstyle ':completion:*:killall:*' command 'ps -e -o comm='

# Turn off menu completion for kill
zstyle ':completion:*:kill:*:processes' insert-ids single

# Don't vi .class files etc
zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.class' '*.pyc' '*.pyo' '*.o'

export TZ='America/Denver'

export PATH=$PATH:/usr/local/bin:~/git-scripts:~/bin:~/bitbucket/random/bin:~/Dropbox/bitbucket/settings/bin:~/.local/bin:/usr/local/go/bin:~/go/bin

# snap binaries
export PATH=$PATH:/snap/bin

# Ryan's tools
export PATH=$PATH:~/git/snippets

# CS machines anaconda path
export PATH="/usr/local/anaconda/bin:$PATH"

# Brazil
export PATH=$PATH:~/.toolbox/bin/

export GOPATH="$HOME/go"

# export PIP_DOWNLOAD_CACHE=~/.pip_download_cache

if [ -e /usr/share/terminfo/x/xterm-256color ] || [ -e /lib/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm'
fi

function title() {
    # Remove "%' signs from $1 (they mess up normal display sometimes)
    #local a=${(V)1//\%/\%\%}
    local a=${(V)1//\%/ }

    # Truncate command, and join lines.
    a=$(print -Pn "%80>...>$a" | tr -d "\n")

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
    local LASTRET=$?
    if [ "$LASTRET" != 0 ] && [ "$preexec_called" = 1 ]; then
        echo -e "\033[1;31mExit code: $LASTRET\033[0m"
    fi

    title "zsh" "%m:%55<...<%~"

    unset preexec_called
}

# preexec is called just before any command line is executed
function preexec() {
    preexec_called=1
    title "$1" "%m:%35<...<%~"
}

function date() {
    if [ "$#" -eq 0 ]; then
        # Override the default date format to my favorite one
        /bin/date +"%A, %B %-e, %Y %-l:%M:%S %#p"
    else
        /bin/date "$@"
    fi
}

# Workaround for dbus not properly exiting (prevents logout and kills dropbox otherwise)
# sometimes 'service messagebus restart' seems to fix it (centos)
export DBUS_SESSION_BUS_ADDRESS=:0.0

# Replaced with https://bitbucket.org/dbesen/random/src/master/dropbox_systemd/
# # If dropbox is installed, check if it's running, and start it if not
# if hostname -f | grep cs.colostate.edu >/dev/null; then
#     trap 'dropbox stop' EXIT
# else # Don't want to auto-start dropbox on cs machines
#     if [ -e ~/bin/dropbox ]; then
#         if dropbox status 2>&1 | grep -q -i "isn't running"
#         then
#             ~/bitbucket/random/bin/start_dropbox
#         fi
#     fi
# fi

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

function deactivate_or_exit() {
    if declare -f deactivate > /dev/null
    then
        deactivate
        echo
        zle reset-prompt
    else
        echo -n exit
        exit
    fi
}
zle -N deactivate_or_exit

setopt IGNORE_EOF
bindkey '^D' deactivate_or_exit

autoload -U zmv
alias mmv='noglob zmv -W' # Allows for mmv *.a *.b

bindkey '^[' beep # disable vim mode

ZLE_REMOVE_SUFFIX_CHARS=""

# Print logged-in-from ip
# echo -n "You are: "
# who | grep --color=no `whoami`

# Make cd ls, and make it easier to open multiple terminals in the same folder
ls
function chpwd() {
    ls
    echo "$PWD" > ~/.cwd;
}

# Also folder bookmarks
function addbookmark() {
    if [ -z "$2" ]; then
        echo "Usage: $0 <bookmark location> <bookmark name>"
        return 1
    fi
    ln -s "$1" "$HOME/.bookmarks/$2"
}

function cds() {
    if [ -z "$1" ]; then
        cd `cat ~/.cwd`
    else
        cd -P "$HOME/.bookmarks/$1" # TODO tab completion for this
    fi
}

# CS machines have shared NFS and I don't want to litter all the machines with dropbox instances.
if hostname -f | grep cs.colostate.edu >/dev/null; then
    trap 'dropbox stop' EXIT
fi

function take() {
    mkdir -p -- "$1"
    cd -- "$1"
}

function nowrap () {
    tput rmam;
    while read -r data; do
        printf "%s\n" "$data"
    done
    tput smam;
}

export NVM_DIR="$HOME/.nvm"
# Commented out since it takes ~2 seconds
alias nvm='echo Comment out this alias and uncomment those slow lines in .zshrc to load nvm'
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completio

alias bb=brazil-build

# complete -C '/usr/local/bin/aws_completer' aws
complete -C 'aws_completer' aws
if which isengardcli &>/dev/null; then
    eval "$(isengardcli shell-autocomplete)"
fi

# For some crazy reason if I put this at the top of this file, it breaks tab completion.  But down here it works.
if [[ "$OSTYPE" == "darwin"* ]]; then
    # mac
    export EDITOR="/usr/local/bin/vim"
    export VISUAL=$EDITOR
else
    # These commands don't work on mac.
    # Set up dir colors for ls and zsh tab completion
    export EDITOR=vim # WTF? This is somehow breaking tab completion.
    export VISUAL=$EDITOR
fi

