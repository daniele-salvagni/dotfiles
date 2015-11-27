#! /bin/bash

## Set the background.
exec sh ~/.scripts/wallpaper.sh &
exec xrdb .Xresources &

## Start i3-gaps
exec i3

