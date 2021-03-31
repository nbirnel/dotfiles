#FIXME PS1 not in mksh
[ -z "$PS1" ] && return         # Check for an interactive session

#FIXME set has different opts in mksh
unset MAILCHECK                 # no "You have mail in ..."

umask 0022          # everyone can use my files by default

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

# GNU dircolors. Will be called as appropriate in os / dist bashrc. Do not export.
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

# See https://gist.github.com/nbirnel/10b5f0903f5c6e7ee9dd189c204d1826
_Chartreuse2='\[\e[38;5;112;1m\]'
_Red3='\[\e[38;5;160;1m\]'
_DeepPink1='\[\e[38;5;198;1m\]'
_DarkOrange='\[\e[38;5;208;1m\]'
_SandyBrown='\[\e[38;5;215;1m\]'
_MistyRose='\[\e[38;5;224;1m\]'
_DarkOliveGreen3='\[\e[38;5;113;1m\]'

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

    if [ -n "$AWS_PROFILE" ]; then
       _aws="${_DarkOliveGreen3} aws $AWS_PROFILE"
    else 
       _aws="$_off"
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
    PS1="$_ps_pref$_ssh$_magenta$_time $_blue\u@\h $_MistyRose\w$_aws$_venv$_git$(__git_ps1)$_untracked $_error\$\n$_off"
}
    
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

type -p vim >/dev/null && export EDITOR=$(type -p vim)     && export EDITOR
type -p vim >/dev/null && export GIT_EDITOR=$(type -p vim) && export GIT_EDITOR
type -p less >/dev/null && export PAGER=$(type -p less)    && export PAGER
type -p vim >/dev/null && export VISUAL=$(type -p vim)       && export VISUAL
type -p firefox >/dev/null && export BROWSER=$(type -p firefox) && export BROWSER
MAIL=/var/spool/mail/noah             && export export MAIL

HISTTIMEFORMAT='%y-%m-%d %H:%M '
export HISTTIMEFORMAT
export HISTFILESIZE=50000
export HISTSIZE=10000

#FIXME mksh has no shopt
# something like this to save multiline commands
# with embedded newlines
#shopt -s lithist
# or like this to 'attempt'(?) to add syntacticly correct
# semicolons
shopt -s cmdhist

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

# cd aliases

# Because openSuse is has already aliased these.
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

alias info="info --vi-keys"

#FIXME mksh won't have this
savehist() {
    HISTFILE="$HOME/.config/bash_history/$@"
    export HISTFILE
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

complete -C /home/nbirnel/bin/vault vault
complete -C /home/nbirnel/bin/terraform terraform

PATH=$PATH:$HOME/.rvm/bin
PATH=$PATH:$HOME/.cargo/bin

test -f $HOME/src/git-hub/.rc && . $HOME/src/git-hub/.rc
test -d $HOME/.cabal/bin && PATH=$PATH:$HOME/.cabal/bin

# Elixir / IEx
export ERL_AFLAGS="-kernel shell_history enabled"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/nbirnel/src/google-cloud-sdk/path.bash.inc' ]; then source '/home/nbirnel/src/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/nbirnel/src/google-cloud-sdk/completion.bash.inc' ]; then source '/home/nbirnel/src/google-cloud-sdk/completion.bash.inc'; fi

#FIXME mksh won't use this?
# reset this last so we don't get a bunch of bashrc in our history
export PATH
set -o history

