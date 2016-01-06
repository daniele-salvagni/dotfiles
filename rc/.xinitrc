#! /bin/bash

## Fonts
xset +fp ~/.fonts
xset +fp /usr/share/fonts/local 
xset fp rehash

## Load X resources if file exists
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

## Set the wallpaper
sh ~/.scripts/wallpaper.sh &

## Run devmon in background
devmon &

## Start the Music Player Daemon
mpd &

## Start i3-gaps
exec dbus-launch --exit-with-session i3
