## begin .bash_profile ##
export VISUAL=vim
export EDITOR=vim

# No need to type cd
shopt -s autocd
# Set custom navigation/display
alias ls='ls -GlhpF --color=auto'
alias ll='ls -GalhpF'
alias l='ls -GlhpF'
alias ..='cd ..'

# Set colors for ls and grep
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
export GREP_OPTIONS='--color=auto'
alias grep="$(which grep) $GREP_OPTIONS"
unset GREP_OPTIONS

# Timesavers
alias s='ssh'
alias g='git'
alias v='vim'
alias reload='source ~/.bash_profile'
alias rmspaces='find . -depth | rename " " "_" *'

# Share screen session
alias csharescreen='screen -dmS sharedscreen'
alias sharescreen='screen -x sharedscreen'

# GNUPG Aliases
alias gpgsign='gpg --sign --clearsign'
alias gpgsignu='gpg --sign --clearsign -u'
alias gpgdecrypt='gpg --decrypt'
alias gpgverify='gpg --verify'
alias gpgencrypt='gpg --armor --encrypt'
alias gpgsym='gpg --armor --symmetric'

# Set colors if available
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    BLACK="\e[90m"
    RED="\e[31m"
    GREEN="\e[92m"
    YELLOW="\e[93m"
    BLUE="\e[94m"
    MAGENTA="\e[95m"
    CYAN="\e[96m"
    WHITE="\e[97m"

    SYSCOLOR=$GREEN

    if [ -a ~/.bash_profile.personal ]; then
        source ~/.bash_profile.personal
        SYSCOLOR=$CYAN
    fi

    if [ -a ~/.bash_profile.ocf ]; then
        source ~/.bash_profile.ocf
        SYSCOLOR=$WHITE
    fi

    if [ -a ~/.bash_profile.nersc ]; then
        source ~/.bash_profile.nersc
        SYSCOLOR=$RED
    fi

    if [ -a ~/.bash_profile.inst ]; then
        source ~/.bash_profile.inst
        SYSCOLOR=$BLUE
    fi
    GIT_CLEAN=$GREEN
    GIT_DIRTY=$RED
else
    SYSCOLOR=
    GIT_CLEAN=
    GIT_DIRTY=
fi

git_branch() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  git_br=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')

  if git diff --quiet 2>/dev/null >&2; then
    git_color="$GIT_CLEAN"
  else
    git_color="$GIT_DIRTY"
  fi

  echo "$git_color($git_br)"
}

# Shell prompt
PROMPT_COMMAND='PS1="\["$SYSCOLOR"\][\u\[\e[0;31m\]@\h\[\e[m\]\[\e[m\]\[\e[0;94m\]:\W\[\e[m\]\["$SYSCOLOR"\]][\D{%Y%m%d %H:%M:%S}]$(git_branch)\["$SYSCOLOR"\]\[\e[m\]\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\$\"; else echo \"\[\033[01;31m\]\$\"; fi) \[\033[01;37m\]"'
#export PS1="\["$SYSCOLOR"\][\u\[\e[0;31m\]@\h\[\e[m\]\[\e[m\]\[\e[0;94m\]:\W\[\e[m\]\["$SYSCOLOR"\]][\D{%Y%m%d %H:%M:%S}]\["$SYSCOLOR"\]\[\e[m\]\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\$\"; else echo \"\[\033[01;31m\]\$\"; fi) \[\033[01;37m\]"
export PS2="[\d \t] continue> "

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# Source RVM if it exists
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" && export PATH="$PATH:$HOME/.rvm/bin"

# Arch Linux Specific
if hash pacman 2>/dev/null; then
    BASE="/home/$USER/Dropbox/Sync/script"
    alias dbx="$BASE/dropbox.py"
    alias sdbx="sudo sysctl -p; $BASE/dropbox.py"

    alias sgdm="sudo systemctl start gdm"

    alias syu='sudo pacman -Syu'
    alias rs='sudo pacman -Rs'

    alias archstart="sudo sysctl -p; $BASE/dropbox.py start; sudo pacman -Syu"

    if hash redshift; then
        alias redshift='redshift -l 40:124'
    fi

    export PATH=$PATH:$BASE
fi

function open() {
    test $# -lt 1 && echo "Too few arguments"
    test $# -gt 1 && echo "Too many arguments"
    EXTENSION=${1#*.}
    case ${EXTENSION,,} in
        pdf)
            evince "$1"
            ;;
        jpg)
            if hash eog 2>/dev/null; then
                eog "$1"
            else
                xdg-open "$1"
            fi
            ;;
        png)
            if hash eog 2>/dev/null; then
                eog "$1"
            else
                xdg-open "$1"
            fi
            ;;
        *)
            xdg-open "$1"
            ;;
    esac
}

## end .bash_profile ##

