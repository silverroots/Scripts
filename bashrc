# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# For Linux Use below script for alert.
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert="osascript -e 'display notification $([ $? = 0 ] && echo terminal || echo error)" with title "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"''


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# ################################################ MY CHANGES ############################################

# Set dir colors
#LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.pcx=01;35:*.yuv=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.flac=01;35:*.mp3=01;35:*.mpc=00;36:*.ogg=00;36:*.wav=00;36:*.mid=00;36:*.midi=00;36:*.au=00;36:*.flac=00;36:*.aac=00;36:*.ra=01;36:*.mka=01;36:';
export LSCOLORS=gxfxcxdxbxegedabagacad

# -- Show the Current GIT Branch in Your Command Prompt --- #

BGREEN="\[\033[1;32m\]"
GREEN="\[\033[0;32m\]"
NO_COLOUR="\[\033[0m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"

function parse_git_branch () {
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
    echo $branch
}

function show_status_bubble() {
    terminal_status_bubble=""
    status_color="2"
    if [[ "$GYP_DEFINES" =~ "OS=android" ]]; then
        if [[ $PWD =~ ^$CHROME_SRC.* ]]
        then 
            status_color=2
            terminal_status_bubble="[AB]"
        else
            status_color=3
            terminal_status_bubble="[AB !pwd]"
        fi
    fi
    if [[ "$GYP_DEFINES" =~ "fastbuild=2" ]]; then
        terminal_status_bubble="$terminal_status_bubble [FB@2]"
    fi
    if [[ "$GYP_DEFINES" =~ "clang=1" ]]; then
        terminal_status_bubble="$terminal_status_bubble [clang]"
    fi
    tput setab $status_color; echo "$terminal_status_bubble";
}

# --------- Different versions of Command Prompt --------- #

#PS1="$GREEN\u@\h: $YELLOW\w $RED\$(parse_git_branch)$NO_COLOUR \$(show_status_bubble)$GREEN \$(date +\"%d:%m:%y %T\")$NO_COLOUR\n\$ "
#export PS1="$GREEN\u@\h: $YELLOW\w $RED\$(parse_git_branch)$NO_COLOUR \$(show_status_bubble)$NO_COLOUR\n\$ "
#PS1="\[\e[32;1m\]\u\[\e[0m\]\[\e[32m\]@\h \[\e[36m\]\w \[\e[33m\]\$ \[\e[0m\]"

PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w$RED \$(parse_git_branch)$NO_COLOUR\[\033[0;37m\]]\n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]$ "

#PS1="\n\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\n\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

# ------------------------------ #

export REAL_NAME="Kaustubh Atrawalkar"
export GREP_OPTIONS="--exclude-dir="\*/.git/\*""
export EMAIL_ADDRESS=katrawalkar@mz.com

# My Scripts
#export PATH="/opt/local/bin:/usr/local/bin:$PATH:$HOME/Scripts"

# chromium depot_tools
#export PATH=$PATH:$HOME/codespace/depot_tools

# ccahe
# export PATH=~/bin:${PATH}
# export USE_CCACHE=1

# Alias
alias cd="cd -P"
alias v='vimi'
alias lr="cd /projects/ixengine/shared/librocket"
alias writelanguage='/projects/odyssey/server/_ix/scripts/write_language_files.php'
alias engine='cd /projects/ixengine'
alias ody='cd /projects/odyssey'
#alias wisologs='tail -f /opt/local/var/log/nginx/error.log /projects/odyssey/log/wiso_dev.log | color_server_log.sh'
#alias odylogs='tail -f /opt/local/var/log/nginx/error.log /projects/odyssey/log/ody_dev.log | color_server_log.sh'
#alias nisologs='tail -f /opt/local/var/log/nginx/error.log /projects/odyssey/log/niso_dev.log | color_server_log.sh'

alias wisologs='diva logs wiso | color_server_log.sh'
alias baw="(cd /projects/ixengine/games/wiso/android; ./gradlew installWisoiapArmv7Debug)"

# ls aliases
alias ls="ls -hG"
alias l="ls -lhG"
alias la="ls -lahG"
alias ..='cd ..'
alias -- -='cd -'

# git aliases
alias gl='tig'
alias gcam='git commit --amend --reset-author --date="$(date)"'
alias gshf='git show --pretty="format:" --name-only'

# Some fancy history stuff
export HISTCONTROL=erasedups  # No duplicates
export HISTSIZE=              # Bigger history
shopt -s histappend # Append to ~/.bash_history
alias h='history | grep' # Easy history grep

export NDK_MODULE_PATH=/projects/ixengine/shared:/tools/android
launchctl setenv NDK_MODULE_PATH $NDK_MODULE_PATH

export SDK_MODULE_PATH=/tools/android/android-sdk

launchctl setenv NDK_MODULE_PATH $NDK_MODULE_PATH

#export DISTCC_DIR=/tools/distcc
#launchctl setenv DISTCC_DIR $DISTCC_DIR

export PATH=/tools/python/macosx-10.12/bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/bin:/tools/android/android-ndk:/tools/android/android-sdk/tools:/tools/android/android-sdk/platform-tools:/tools/android/bin:$HOME/Scripts:/usr/local/go/bin:/tools/bin:$PATH
launchctl setenv PATH $PATH

# Shell Intergration for iTerm 3 (MacOS)
source ~/.iterm2_shell_integration.`basename $SHELL`

# find file(s) and open them in vim
function ffv() {
    vim -o `ff $1`
}

# chainge to the directory of the first of the found files
function ffd() {
    cd `ff $1 | head -n 1 | xargs dirname`
}

# ssh into featurebranch
sshfeaturefunction() {
local env=$(printf %d $1)
/usr/bin/ssh -o LogLevel=error -t las1-1-002.idm.mz-inc.com "/usr/local/bin/ssh_as_root isofeature-$env-001.iso.dev.las1.mz-inc.com"
}
alias sshfeature=sshfeaturefunction
