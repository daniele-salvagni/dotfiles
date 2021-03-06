#!/bin/bash

pkill lemonbar

font1="tewi:pixelsize=10:antialias=true"
font2="siji:pixelsize=11"
bg_color="#982c2c"
fg_color="#b49f85"

fifo="/tmp/.fifo"
[ -e $fifo ] && rm $fifo
mkfifo $fifo

/home/dan/.i3/lemonbar/components/bat.sh > $fifo &
/home/dan/.i3/lemonbar/components/dat.sh > $fifo &
/home/dan/.i3/lemonbar/components/net.sh > $fifo &
/home/dan/.i3/lemonbar/components/thc.sh > $fifo &
/home/dan/.i3/lemonbar/components/vol.sh > $fifo &
/home/dan/.i3/lemonbar/components/wsp.sh > $fifo &

cat $fifo | .i3/lemonbar/bar.py | lemonbar -n bar-main -p -B#4a4a4a -F#8e8e8e -g 1600x20+0+0 -f 'tewi:pixelsize=10:antialias=true' -f 'siji:pixelsize=11' | bash
