#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

test -f $sysresources    && xrdb -merge  $sysresources
test -f $sysmodmap       && xmodmap      $sysmodmap
test -f "$userresources" && xrdb -merge "$userresources"
test -f "$usermodmap"    && xmodmap     "$usermodmap"

# start some nice programs
eval $(ssh-agent)

test $(which xsetroot)  && xsetroot -solid midnightblue &
test $(which st)        && st -e $(which bash) --login &
test $(which conky)     && conky &
test $(which gpg-agent) && eval $(gpg-agent --daemon)
test $(which numlockx)  && numlockx on

if [ $(which xbanish) ]; then
    xbanish >>$HOME/.xbanish.log &    # https://github.com/jcs/xbanish
elif [ $(which unclutter) ]; then
    unclutter &
fi

# source machine- and uname-specific xinitrcs
xinitcfg="$HOME/.config/xinit"
test -f "$xinitcfg/u/$(uname)"       && . "$xinitcfg/u/$(uname)"
test -f "$xinitcfg/host/$(hostname)" && . "$xinitcfg/host/$(hostname)"

#enable sticky keys, and latchlock, and do not expire
if [ $(which xkbset) ]; then
    xkbset -bell -feedback sticky -twokey latchlock
    xkbset exp 64 '=sticky' '=twokey' '=latchlock'
fi

xautolock -time 10 -locker /usr/local/bin/slock -notify 60 \
  -notifier 'echo "60s" | dmenu -fn "xft:terminus:pixelsize=180"' &

dwmstatus &
/usr/local/bin/dwm 2>>.dwm_log
