#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# awesome is kept as default
DEFAULT_SESSION=awesome

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

# Speed up rxvt-unicode
urxvtd -q -f -o

# Start up apps
blueman-applet &
redshift-gtk &

# launch
exec dbus-launch --sh-syntax --exit-with-session awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
