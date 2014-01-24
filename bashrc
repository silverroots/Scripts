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
HISTSIZE=1000
HISTFILESIZE=2000

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
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

# -- Show the Current GIT Branch in Your Command Prompt --- #

function determine_webkit_trunk_revision() {
    git log -n1 2> /dev/null | grep git-svn-id -m 1 | awk -F '@' '{print $2}' | awk '{print "@"$1}'
}

function parse_git_branch () {
    branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
    if [[ $branch == \(cl* ]];
        then
        reviewId=`echo ${branch:3:8}`
        echo -n "http://crrev.com/$reviewId "
    fi
    if [ "$branch" = "(master)" -o "$branch" = "(trunk)" ];
        then
        tput smul
        tput bold
    fi
    echo $branch
}

function is_building_for_android() {
    if [ "$ANDROID_SDK_BUILD" = "1" ]; then
        case $PWD/ in
            $CHROME_SRC/*) echo "Android Build";
        esac
    fi
}

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NO_COLOUR="\[\033[0m\]"
#PS1="$GREEN\u$NO_COLOUR@$RED\h$NO_COLOUR:\w$YELLOW\$(parse_git_branch)$NO_COLOUR\$ "
PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w$RED \$(parse_git_branch)$YELLOW \$(is_building_for_android)$NO_COLOUR\[\033[0;37m\]]\n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]$ "


#PS1="\n\[\033[1;37m\]\342\224\214($(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h'; else echo '\[\033[01;34m\]\u@\h'; fi)\[\033[1;37m\])\342\224\200(\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi)\[\033[1;37m\])\342\224\200(\[\033[1;34m\]\@ \d\[\033[1;37m\])\[\033[1;37m\]\n\342\224\224\342\224\200(\[\033[1;32m\]\w\[\033[1;37m\])\342\224\200(\[\033[1;32m\]\$(ls -1 | wc -l | sed 's: ::g') files, \$(ls -lah | grep -m 1 total | sed 's/total //')b\[\033[1;37m\])\342\224\200> \[\033[0m\]"

# ------------------------------ #

export REAL_NAME="Kaustubh Atrawalkar"
export GREP_OPTIONS="--exclude-dir="\*/.svn/\*""
export EMAIL_ADDRESS=kaustubh.a@samsung.com

# My Scripts
export PATH=$PATH:$HOME/Scripts

# chromium depot_tools
export PATH=$PATH:$HOME/codespace/depot_tools

# Android tools
export PATH=${PATH}:~/android-sdk/tools
export PATH=${PATH}:~/android-sdk/platform-tools
export ANDROID_SDK_ROOT=$HOME/android-sdk
# export ANDROID_NDK_ROOT=$HOME/android-ndk

# ccahe
# export PATH=~/bin:${PATH}
# export USE_CCACHE=1

# Tizen SDK configuration
# This is generated by Tizen SDK. Please do not modify by yourself.
# Set sdb environment path
export PATH=$PATH:$HOME/tizen-sdk/tools
# End Tizen SDK configuration

#Tizen obs build
export PATH=$PATH:$HOME/codespace/obs-build

# Alias
alias cd="cd -P"
alias wk='cd $HOME/codespace/WebKit-OS/WebKit'
alias tw='cd $HOME/codespace/webkit-efl'
alias cr='cd $HOME/codespace/chromium/src'
alias rb='remoteDebugging.sh --build'
alias rbo='remoteDebugging.sh --build --online'
alias ri='remoteDebugging.sh --install'
alias rie='remoteDebugging.sh --install --external'
alias crb='ninja -C out/Debug'

# Chrome Sandbox
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox

export https_proxy="http://107.108.85.10:80"
export http_proxy="http://107.108.85.10:80"
