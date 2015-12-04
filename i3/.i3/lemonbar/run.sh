#!/bin/bash

font1="tewi:pixelsize=10:antialias=true"
font2="siji:pixelsize=11"
bg_color="#982c2c"
fg_color="#b49f85"

fifo="/tmp/.fifo"
[ -e $fifo ] && rm $fifo
mkfifo $fifo

xtitle -sf 'T%s' > $fifo &
/home/dan/.i3/lemonbar/components/bat.sh > $fifo &
/home/dan/.i3/lemonbar/components/dat.sh > $fifo &
/home/dan/.i3/lemonbar/components/net.sh > $fifo &
/home/dan/.i3/lemonbar/components/thc.sh > $fifo &
/home/dan/.i3/lemonbar/components/vol.sh > $fifo &
/home/dan/.i3/lemonbar/components/wsp.sh > $fifo &

cat $fifo | .i3/lemonbar/bar.py | lemonbar -n bar-main -p -B#982c2c -F#b49f85 -g 1600x20+0+0 -f 'tewi:pixelsize=10:antialias=true' -f 'siji:pixelsize=11' | bash

