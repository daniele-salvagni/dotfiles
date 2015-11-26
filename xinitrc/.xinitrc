#! /bin/bash

## Set the background.
exec sh ~/.scripts/.fehbg &
exec xrdb .Xresources &

## Start i3-gaps
exec i3
