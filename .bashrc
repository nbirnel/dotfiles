#FIXME PS1 not in mksh
[ -z "$PS1" ] && return         # Check for an interactive session

#FIXME set has different opts in mksh
unset MAILCHECK                 # no "You have mail in ..."

umask 0022          # everyone can use my files by default!

#FIXME not bashrc - profile?
[ -z $BASHRC_HAS_RUN ] \
    && PATH="$HOME/bin:/bin:/usr/local/bin:/usr/bin:$PATH"
BASHRC_HAS_RUN=1                  && export BASHRC_HAS_RUN
export PATH

#FIXME mksh has no shopt
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
[ -x /opt/local/bin/lesspipe.sh ] \
    && export LESSOPEN='| /opt/local/bin/lesspipe.sh %s'

# GNU dircolors. Will be called as appropriate in os / dist bashrc. No export!
DIRCS=$HOME/.dir_colors

_off='\[\e[0m\]'
_black='\[\e[30m\]'
_red='\[\e[31m\]'
_green='\[\e[32m\]'
_orange='\[\e[33m\]'
_blue='\[\e[34m\]'
_maroon='\[\e[35m\]'
_cyan='\[\e[36m\]'
_white='\[\e[37m\]'
_contrast="$_white"

_prompt_command() {
    if test $? = 0; then
        _error="$_green"
    else
        _error="$_red"
    fi

    #FIXME mksh probably doesn't have this
    # append history after each command
    history -a
    if test -n "$SSH_CONNECTION"; then
        _ssh="$_orange($(echo $SSH_CONNECTION | cut -d' ' -f1)) "
    else
        _ssh=""
    fi

    _title="$PWD"
    echo -ne '\e]0;'"$_title"'\a'

    _time="$(date '+%H:%M %a %b %d')"
   #                             user host   where        
    PS1="$_ps_pref$_ssh$_maroon$_time $_blue\u@\h $_contrast\w $_error\$\n$_off"
}
    
#FIXME mksh has no PS1
#FIXME make colors vars :
# _maroon='\[\e[35m\]'
# _time='\@'
#case $TERM in 
#	cons* )
#        MAROON  time date BLUE  user host  RED  directory    prompt  WHITE
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[37m\]"
#	;;
#	cygwin* )
#        MAROON  time date BLUE  user host  RED  directory    prompt  WHITE
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[37m\]"
#	;;
#	* )
#        MAROON  time date BLUE  user host  RED  directory    prompt  WHITE
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[37m\]"
#        MAROON  time date BLUE  user host  RED  directory    prompt  BLACK
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[30m\]"
#	;;
#esac

#}

PROMPT_COMMAND=_prompt_command

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi

#environmental variables

#FIXME mksh type is an alias for whence - use which?
type -p vim >/dev/null && export EDITOR=$(type -p vim)     && export EDITOR
type -p vim >/dev/null && export GIT_EDITOR=$(type -p vim) && export GIT_EDITOR
type -p less >/dev/null && export PAGER=$(type -p less)    && export PAGER
type -p vim >/dev/null && export VISUAL=$(type -p vim)       && export VISUAL
type -p firefox >/dev/null && export BROWSER=$(type -p firefox) && export BROWSER
MAIL=/var/spool/mail/noah             && export export MAIL

if [ -d /opt/plan9 ]; then
    PLAN9=/opt/plan9 && export PLAN9
elif [ -d /usr/local/plan9 ]; then
    PLAN9=/opt/plan9 && export PLAN9
fi

#FIXME mksh type is an alias for whence - use which?
# reminders!
type -t remind > /dev/null
[ $? == 0 -a -e ~/.remind/master ] && remind ~/.remind/master

#FIXME mksh might not have this?
HISTTIMEFORMAT='%y-%m-%d %H:%M '
export HISTTIMEFORMAT
HISTTIMEFORMAT='%y-%m-%d %H:%M '
export HISTTIMEFORMAT
HISTFILESIZE=50000
export HISTFILESIZE

#FIXME mksh has no shopt
# something like this to save multiline commands
# with embedded newlines
#shopt -s lithist
# or like this to 'attempt'(?) to add syntacticly correct
# semicolons
shopt -s cmdhist

# surfraw elvii
PATH=$PATH:/usr/local/lib/surfraw

# god I hate screen(1)
SCREENDIR=$HOME/.screen; export SCREENDIR

#nosql setenv overwrites path
#eval $(nosql setenv) 
TMPDIR=/tmp
NOSQL_CHARSET=utf-8
NOSQL_INSTALL=/usr/local/nosql
SWU_INSTALL=/usr/local/swu
PATH="$PATH:/usr/local/swu/bin:/usr/local/nosql/bin"
export NOSQL_INSTALL SWU_INSTALL PATH TMPDIR NOSQL_CHARSET

alias cdd='cd $HOME/Desktop'

_BASH_CONFIGDIR="$HOME/.config/bash"
_BASH_OS_CONFIGDIR="$_BASH_CONFIGDIR/osrc"
_BASH_DIST_CONFIGDIR="$_BASH_CONFIGDIR/distrc"
_BASH_LOCAL_CONFIGDIR="$HOME/.config/bash_local"

case "$(uname)" in
    ARCH)
        _DISTRC="$_BASH_DIST_CONFIGDIR/archlinux"
        ;;
    debian)
        _DISTRC="$_BASH_DIST_CONFIGDIR/debian"
        ;;
    FreeBSD)
        _DISTRC="$_BASH_DIST_CONFIGDIR/freebsd"
        ;;
    CYGWIN*)
        _DISTRC="$_BASH_DIST_CONFIGDIR/cygwin"
        ;;
    MINGW32*)
        _DISTRC="$_BASH_DIST_CONFIGDIR/mingw"
        ;;
    Darwin*)
        _DISTRC="$_BASH_DIST_CONFIGDIR/osx"
        ;;
    Linux*)
        _DISTRC="$_BASH_DIST_CONFIGDIR/linux"
        ;;
esac

which zypper 1>/dev/null 2>/dev/null && _DISTRC="$_BASH_DIST_CONFIGDIR/suse"

_LOCALRC="$_BASH_LOCAL_CONFIGDIR/$(hostname)"

test -f "$_DISTRC" && . "$_DISTRC"
test -f "$_OSRC" && . "$_OSRC"
test -f "$_LOCALRC" && . "$_LOCALRC"

alias vimrc='vim "$HOME/.bashrc"'
alias vimrcd='vim "+set ft=sh" "$_DISTRC"'
alias vimrco='vim "+set ft=sh" "$_OSRC"'
alias vimrcl='vim "+set ft=sh" "$_LOCALRC"'

# cd aliases

..() { 
    if [ -n "$1" ]; then cd ../"$1";  # one move so "cd -" still good
    else cd ..;
    fi
}

...() { 
    if [ -n "$1" ]; then cd ../../"$1";
    else cd ../..;
    fi
}

....() { 
    if [ -n "$1" ]; then cd ../../../"$1";
    else cd ../../..;
    fi
}

.....() { 
    if [ -n "$1" ]; then cd ../../../../"$1";
    else cd ../../../..;
    fi
}

......() { 
    if [ -n "$1" ]; then cd ../../../../../"$1";
    else cd ../../../../..;
    fi
}

.......() { 
    if [ -n "$1" ]; then cd ../../../../../../"$1";
    else cd ../../../../../..;
    fi
}

........() { 
    if [ -n "$1" ]; then cd ../../../../../../../"$1";
    else cd ../../../../../../..;
    fi
}

alias cls='clear'
alias chx='chmod +x'

alias psgr='ps -e | grep'

alias vo='vim -O'

alias glinks='links -g'
alias u2l='tr [:upper:] [:lower:]'
alias l2u='tr [:lower:] [:upper:]'

alias rem='remind ~/.remind/master'

alias pingt='ping -c 4 www.google.com'

alias gg='surfraw google'
alias wp='surfraw wikipedia'

alias manm="man -M $HOME/man"
alias manp="man -M $HOME/usr/share/man/posix"
alias info="info --vi-keys"

#FIXME this belongs in bsd?
# sudo aliases
alias cdrip='sudo cdrip'

c( ) {
   # eg c .h.n = cd /home/noah/.
   # not sure where I stole this from, but the original could
   # only do absolute paths, take single letter abbreviations
   # with no wildcards, and the regex stunk.
   # 2011 12 02 added support for spaces, made portable to non-GNU
   # sed.
   dir="$@"

   # Append * to non-dot sequences, change spaces to *, translate dots to / 
   # and add
   # final "/." to be sure this only matches a directory:
   dirpat="$(echo $dir | sed 's#\([^.][^.]*\)#\1*#g; s/  */*/g' | tr . /)/."

   # In case $dirpat is empty, set dummy "x" then shift it away:
   set x $dirpat; shift

   # Do the cd if we got one match, else print error:
   if [ "$1" = "$dirpat" ]; then
      # pattern didn't match (shell didn't expand it)
      echo "c: no match for $dirpat" 1>&2
   elif [ $# = 1 ]; then
      cd "$1"
   else
      echo "c: too many matches for $dir:" 1>&2
      ls -d "$@"
   fi

   unset dir dirpat
}

cm() {
    if [ -n "$dest" ]; then
        _tmp_dest="$dest"
        _reset_dest=1
    fi
    
    dest="$(mo $@)"
    [ "$?" -ne 0 ] && unset dest && return 1
    if [ -z "$dest" ]; then
        echo "$@ is an empty mark."
        unset dest
        return 1
    elif [ ! -d "$dest" ]; then
        echo "$dest is not a directory."
        unset dest
        return 1
    else
        cd "$dest"
    fi

    unset dest
    [ "$_reset_dest" ] && dest="$_tmp_dest" && unset _tmp_dest
}

shc() {
    echo "scale=9;$@" | bc
}

h() {
    history | tail -r | sed 's/ *[1-9][0-9]* *//;/^#/d;1d' | dmenu -b
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

carry() {

    argc=0

    for arg; do
        case $arg in 
          *) eval arg_$argc=\$arg
             argc=$(expr $argc + 1)
             ;;
        esac
    done

    eval "dest=\${$#}"

    shift $#
    argc=$(expr $argc - 1)

    while test $argc -gt 0; do
        argc=$(expr $argc - 1)
        eval 'set -- "$arg_'$argc'" "$@"'
        unset arg_$argc
    done

    mv "$@" "$dest" && {
        if [ -d "$dest" ]; then
            cd "$dest"
        else
            cd "$(echo "$dest" | sed 's,[^/]\+/\?$,,')"
        fi
    }
    unset dest
}

#FIXME factor out dupes!

follow() {

    argc=0

    for arg; do
        case $arg in 
          *) eval arg_$argc=\$arg
             argc=$(expr $argc + 1)
             ;;
        esac
    done

    eval "dest=\${$#}"

    shift $#
    argc=$(expr $argc - 1)

    while test $argc -gt 0; do
        argc=$(expr $argc - 1)
        eval 'set -- "$arg_'$argc'" "$@"'
        unset arg_$argc
    done

    cp "$@" "$dest" && {
        if [ -d "$dest" ]; then
            cd "$dest"
        else
            cd "$(echo "$dest" | sed 's,[^/]\+/\?$,,')"
        fi
    }
    unset dest
}

#FIXME mksh won't have this
savehist() {
    HISTFILE="$HOME/.config/bash_history/$@"
    export HISTFILE
}

#alias pgen='pwgen -n -c -y 8 1' #one number, one upper, one non-alnum
#alias pgens='pwgen -n -c -y -s 8 1' #one number, one upper, one non-alnum, 'secure'
spgen() {
    if [ $# = 1 ]; then
        len=$1
        num=1
    elif [ $# = 2 ]; then
        len=$1
        num=$2
    else
        len=8
        num=1
    fi
    #one number, one upper, one non-alnum, one per line, secure
    pwgen -n -c -y -1 -s $len $num 
}

pgen() {
    if [ $# = 1 ]; then
        len=$1
        num=1
    elif [ $# = 2 ]; then
        len=$1
        num=$2
    else
        len=8
        num=1
    fi
    #one number, one upper, one non-alnum, one per linee
    pwgen -n -c -y -1 $len $num
}

filect() {
    find "$@" -type f | sort -u | wc
}

gitp() {
    while [ $# -gt 0 ]; do
        case "$1" in
          -ls)
            shift 
            ls "$HOME/.config/gitp"
            return
            ;;
          --edit-config)
            $EDITOR "$HOME/.config/gitp/$2/config"
            return $?
            ;;
          --edit-exclude)
            $EDITOR "$HOME/.config/gitp/$2/info/exclude"
            return $?
            ;;
          --scp-config)
            remote="$(gitp "$2" remote show -n "$3" |\
                      sed -n 's/ *Fetch URL: *//p')"
            scp "$remote/config" "$HOME/.config/gitp/$2/"
            return $?
            ;;
          --scp-exclude)
            remote="$(gitp "$2" remote show -n "$3" |\
                      sed -n 's/ *Fetch URL: *//p')"
            scp "$remote/info/exclude" "$HOME/.config/gitp/$2/info/"
            return $?
            ;;
          -*)
            echo "Unknown flag $1" 1>&2
            return 1
            ;;
          *)
            break
            ;;
        esac
    done

    #dot, doc, personal, secure, work, work-secure
    dir="$1"
    shift
    ( cd ~ && git --work-tree=./ --git-dir="./.config/gitp/$dir" $@)
}

authme() {
    cat "$HOME"/.ssh/id_*sa.pub \|
      ssh "$@" 'cat - >>"$HOME/.ssh/authorized_keys"'
}

#FIXME mksh won't use this?
# reset this last so we don't get a bunch of bashrc in our history
set -o history

