#! /bin/bash

## Set the background.
sh ~/.scripts/wallpaper.sh &

## Load X resources if file exists
[[ -f ~/.Xresources ]] && xrdb ~/.Xresources

## Start i3-gaps
exec dbus-launch --exit-with-session i3
