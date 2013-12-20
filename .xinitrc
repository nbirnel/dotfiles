#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

#BEGIN Suse
# Sample .xinitrc for SuSE Linux
# This script is called from 'startx' when you start an X session


# In case everything goes wrong, we at least fall back to a plain xterm

#failsafe="uxterm -ls -T Failsafe -geometry 80x24-0-0"
#trap "exec $failsafe" EXIT SIGHUP SIGINT SIGPIPE SIGTERM SIGIO


# Some bash (1 and 2) settings to avoid trouble on a
# failed program call.

#set +e > /dev/null 2>&1
#set +u > /dev/null 2>&1
#set +o posix  > /dev/null 2>&1
#if type shopt > /dev/null 2>&1 ; then
#    shopt -s execfail
#else
#    no_exit_on_failed_exec=1
#fi


# Run user xinit scripts.

#for script in /etc/X11/xinit/xinitrc.d/*; do
#    test -d $script && continue
#    test -x $script || continue
#    case "$script" in
#	.*)		continue ;;
#	*.rpm*)		continue ;;
#	*.swap)		continue ;;
#	*.bak)		continue ;;
#	*.orig)		continue ;;
#	\#*)		continue ;;
#	*~)		continue ;;
#    esac
#    $script
#done
#unset script

# Source common code shared between the
# X session and X init scripts
#
#[ -x /etc/X11/xinit/xinitrc.common ] && .  /etc/X11/xinit/xinitrc.common

# Uncomment next lines to activate asking for ssh passphrase
#
# if test -S "$SSH_AUTH_SOCK" -a -x "$SSH_ASKPASS"; then
#       ssh-add < /dev/null
# fi

# end Suse

# start some nice programs
eval $(ssh-agent)

test $(which xsetroot) && xsetroot -solid midnightblue &
test $(which unclutter) && unclutter &
test $(which st) && st &
test $(which conky) && conky &

test -f "$HOME/.config/xinit/u/$(uname)" && . "$HOME/.config/xinit/u/$(uname)"
test -f "$HOME/.config/xinit/host/$(hostname)" && . "$HOME/.config/xinit/host/$(hostname)"

# re-starts dwm when it is killed
while :; do
    /usr/local/bin/dwm 2>>.dwm_log
done  &

if [ $(which dwmstatus) ]; then
    dwmstatus
else
    uxterm -ls -T Failsafe -geometry 80x24-0-0
fi
