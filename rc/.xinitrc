#! /bin/bash

## Set the background.
exec sh ~/.scripts/wallpaper.sh &

## Load X resources
exec xrdb .Xresources

## Start i3-gaps
exec dbus-launch --exit-with-session i3
