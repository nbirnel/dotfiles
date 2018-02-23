#FIXME PS1 not in mksh
[ -z "$PS1" ] && return         # Check for an interactive session

#FIXME set has different opts in mksh
unset MAILCHECK                 # no "You have mail in ..."

umask 0022          # everyone can use my files by default!

#FIXME not bashrc - profile?
[ -z $BASHRC_HAS_RUN ] \
    && PATH="$HOME/bin:/bin:/usr/local/bin:/usr/bin:$PATH:/usr/local/go/bin:$HOME/.local/bin:$HOME/.cargo/bin"
BASHRC_HAS_RUN=1                  && export BASHRC_HAS_RUN

#FIXME mksh has no shopt
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
[ -x /opt/local/bin/lesspipe.sh ] \
    && export LESSOPEN='| /opt/local/bin/lesspipe.sh %s'

# modern and american
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# GNU dircolors. Will be called as appropriate in os / dist bashrc. No export!
DIRCS=$HOME/.dir_colors

_off='\[\e[0m\]'
_black='\[\e[30;1m\]'
_red='\[\e[31;1m\]'
_green='\[\e[32;1m\]'
_yellow='\[\e[33;1m\]'
_blue='\[\e[34;1m\]'
_magenta='\[\e[35;1m\]'
_cyan='\[\e[36;1m\]'
_white='\[\e[37;1m\]'
_contrast="$_white"

_Chartreuse2='\[\e[38;5;112;1m\]'
_Red3='\[\e[38;5;160;1m\]'
_DeepPink1='\[\e[38;5;198;1m\]'
_DarkOrange='\[\e[38;5;208;1m\]'
_SandyBrown='\[\e[38;5;215;1m\]'
_MistyRose='\[\e[38;5;224;1m\]'

if test -n "$SSH_CONNECTION"; then
    _ssh="$_yellow($(echo $SSH_CONNECTION | awk '{ printf("%s->%s", $1, $3) }')) "
else
    _ssh=""
fi

export GIT_PS1_SHOWDIRTYSTATE=1

_prompt_command() {
    # _error must be first; otherwise any other conditionals will bust it.
    if test $? = 0; then
        _error="$_green"
    else
        _error="$_red"
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
       _venv="${_SandyBrown} venv"
    else 
       _venv="$_off"
    fi

    _s="$(git status 2>/dev/null)"
    if printf "$_s" | grep '^Changes not staged for commit:$' >/dev/null 2>&1
        then _git="$_Red3" && _untracked=''
    elif printf "$_s" | grep '^Changes to be committed:$' >/dev/null 2>&1 
        then _git="$_DarkOrange" && _untracked=''
    elif printf "$_s" | grep '^nothing added to commit but untracked files present' >/dev/null 2>&1 
        then _git="$_Chartreuse2" && _untracked="${_DarkOrange}+"
    else
        _git="$_Chartreuse2" && _untracked=''
    fi

    #FIXME mksh probably doesn't have this
    # append history after each command
    history -a

    _title="$PWD"
    echo -ne '\e]0;'"$_title"'\a'

    _time="$(date '+%H:%M %a %b %d')"
   #                                        user host        where        
    PS1="$_ps_pref$_ssh$_magenta$_time $_blue\u@\h $_MistyRose\w$_venv$_git$(__git_ps1)$_untracked $_error\$\n$_off"
}
    
#FIXME mksh has no PS1
#FIXME make colors vars :
# _magenta='\[\e[35m\]'
# _time='\@'
#case $TERM in 
#	cons* )
#        magenta  time date BLUE  user host  RED  directory    prompt  WHITE
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[37m\]"
#	;;
#	cygwin* )
#        magenta  time date BLUE  user host  RED  directory    prompt  WHITE
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[37m\]"
#	;;
#	* )
#        magenta  time date BLUE  user host  RED  directory    prompt  WHITE
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[37m\]"
#        magenta  time date BLUE  user host  RED  directory    prompt  BLACK
#	PS1="\[\e[35m\]\@ \d \[\e[34m\]\u@\h \[\e[31m\]\w\[\e[31m\]\n\$\[\e[30m\]"
#	;;
#esac

#}

PROMPT_COMMAND=_prompt_command

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# Needed this on Cent 7, but it breaks Ubuntu 14. 
#for i in $(ls /etc/bash_completion.d/); do
#    . /etc/bash_completion.d/$i
#done

#environmental variables

#FIXME mksh type is an alias for whence - use which?
type -p vim >/dev/null && export EDITOR=$(type -p vim)     && export EDITOR
type -p vim >/dev/null && export GIT_EDITOR=$(type -p vim) && export GIT_EDITOR
type -p less >/dev/null && export PAGER=$(type -p less)    && export PAGER
type -p vim >/dev/null && export VISUAL=$(type -p vim)       && export VISUAL
type -p firefox >/dev/null && export BROWSER=$(type -p firefox) && export BROWSER
MAIL=/var/spool/mail/noah             && export export MAIL

test -d $HOME/.cabal/bin && PATH=$PATH:$HOME/.cabal/bin

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

# god I hate screen(1)
SCREENDIR=$HOME/.screen; export SCREENDIR

_BASH_CONFIGDIR="$HOME/.config/bash"
_BASH_OS_CONFIGDIR="$_BASH_CONFIGDIR/osrc"
_BASH_DIST_CONFIGDIR="$_BASH_CONFIGDIR/distrc"
_BASH_LOCAL_CONFIGDIR="$HOME/.config/bash_local"

case "$(uname)" in
    ARCH)
        _DISTRC="$_BASH_DIST_CONFIGDIR/archlinux"
        ;;
    OpenBSD)
        _DISTRC="$_BASH_DIST_CONFIGDIR/openbsd"
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
which apt-get 1>/dev/null 2>/dev/null && _DISTRC="$_BASH_DIST_CONFIGDIR/debian"

_LOCALRC="$_BASH_LOCAL_CONFIGDIR/$(hostname)"

test -f "$_DISTRC" && . "$_DISTRC"
test -f "$_OSRC" && . "$_OSRC"
test -f "$_LOCALRC" && . "$_LOCALRC"

alias vimrc='vim "$HOME/.bashrc"'
alias vimrcd='vim "+set ft=sh" "$_DISTRC"'
alias vimrco='vim "+set ft=sh" "$_OSRC"'
alias vimrcl='vim "+set ft=sh" "$_LOCALRC"'

# cd aliases

# Because openSuse is has already aliases these.
unalias .. 2>/dev/null
unalias ... 2>/dev/null
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

alias gg='surfraw google'
alias wp='surfraw wikipedia'

alias info="info --vi-keys"

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


#FIXME make dmenu or pick (from UPE) depending on [ -z "$DISPLAY" ]
r() {
    history | tail | sed 's/[-0-9: ]*//' | uniq | dmenu -l 10
}

h() {
    history | sed 's/[-0-9: ]*//' | sort -u | dmenu -l 30
}

rx() {
    $(r)
}

hx() {
    $(h)
}

_follow_funs_helper() {
    #FIXME this needs to return a correct exit status
    #FIXME fails weirdly on carrybk spec-dirs-3rd-pass if no $OLDPWD
    action=$1
    shift
    if [ $1 = back ]; then
        _dest="$OLDPWD"
        shift
    elif [ $1 = last ]; then      #this ludicrous thing
        shift                     #strips off the last arg.
        argc=0

        for arg; do
            case $arg in 
              *) eval arg_$argc=\$arg
                 argc=$(expr $argc + 1)
                 ;;
            esac
        done

        eval "_dest=\${$#}"

        shift $#
        argc=$(expr $argc - 1)

        while test $argc -gt 0; do
            argc=$(expr $argc - 1)
            eval 'set -- "$arg_'$argc'" "$@"'
            unset arg_$argc
        done
    fi

    $action "$@" "$_dest" && {
        if [ -d "$_dest" ]; then
            cd "$_dest"
        else
            #what is this sed thing? shouldn't we bail?
            #anyway, ? and + are not portable.
            #cd "$(echo "$_dest" | sed 's,[^/]\+/\?$,,')"
            cd "$(echo "$_dest" | sed 's,[^/][^/]*/\{0,1\}$,,')"
        fi
    }
    unset _dest
}

follow() {
    _follow_funs_helper cp last "$@"
}

carry() {
    _follow_funs_helper mv last "$@"
}

followbk() {
    _follow_funs_helper cp back "$@"
}

carrybk() {
    _follow_funs_helper mv back "$@"
}

cpbk() {
    cp "$@" "$OLDPWD"
}

mvbk() {
    mv "$@" "$OLDPWD"
}

#FIXME mksh won't have this
savehist() {
    HISTFILE="$HOME/.config/bash_history/$@"
    export HISTFILE
}

# git hub command
test -f $HOME/src/git-hub/init && . $HOME/src/git-hub/init

#FIXME mksh won't use this?
# reset this last so we don't get a bunch of bashrc in our history
export PATH
set -o history

complete -C /home/nbirnel/bin/terraform terraform

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/.cargo/bin

