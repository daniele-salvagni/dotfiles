#!/bin/bash
HIGHLIGHT="#ffffff"

clock() {
  # Display the current date and time like: 'Thu 25 Nov  9:58 PM'
  echo "$(date '+%a %d %b %l:%M %p')"
}

workspace() {
  # Workspaces must be prefixed with a number followed by the '=' character,
  # like: 1=Workspace 1, 2=Workspace 2, ..., 10=Workspace 10
  # The prefix is needed for ordering purposes in i3 and will be stripped off
  # automatically in this script.

  # Bug: Does not work correctly for workspaces containing the ':' character,
  # it looks like it is messing with the event closing tag ':}', maybe a
  # lemonbar bug? (not tested)

  # Scrollwheel events (previous/next)
  workspacenext="A4:i3-msg workspace next_on_output:"
  workspaceprevious="A5:i3-msg workspace prev_on_output:"

  # Sample output for 'wmctrl -d':
  # 0  - DG: N/A  VP: 0,0  WA: N/A  1=Workspace 1
  # 1  * DG: N/A  VP: 0,0  WA: N/A  2=Workspace 2
  # 2  - DG: N/A  VP: 0,0  WA: N/A  3=Workspace 10

  # The first AWK is to keep only relevant information, * marks the current 
  # workspace:
  # -1=Workspace 1 
  # *2=Workspace 2
  # -10=Workspace 10

  wslist=$(\

    wmctrl -d \
    | awk '{print $2 substr($0, index($0,$9))}'\
    | awk '{
      ws=gensub("[\\*-][0-9]+=", "", "1", $1)
    }
    /^\*/ {
      print "%{B#817267}%{F#332D29} " ws " %{F-}%{B-}"
    }
    /^-/ {
      print "%{A:i3-msg workspace " substr($0,2) ":} " ws " %{A}"
    }' | paste -d '\0' -s \
  )

  # Adds the scrollwheel events and displays the switcher
  echo "%{$workspacenext}%{$workspaceprevious}$wslist%{A}%{A}"

  # TODO: Urgent workspaces
}

network() {
  # The following assumes 3 interfaces: loopback, ethernet, wifi
  read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`

  # iwconfig returns an error code if the interface tested has no wireless
  # extensions
  if iwconfig $int1 >/dev/null 2>&1; then
    wifi=$int1
    eth0=$int2
  else 
    wifi=$int2
    eth0=$int1
  fi

  # In case of only one interface, just set it here:
  # int=eth0

  # this line will set the variable $int to 'ETH' if it's up, and 'WiFi'
  # otherwise. It is assumed that if ethernet is UP, then it has priority over
  # wifi.
  ip link show $eth0 | grep 'state UP' >/dev/null && int="ETH" || int="WiFi"

  # Send a single packet, to speed up the test. (Google DNS: 8.8.8.8)
  #ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "connected" || echo "disconnected"

  if [[ $int == "ETH" ]]; then
    echo "%{F#504339}%{F-}"
  else
    echo "%{F#817267}     %{F-}"
  fi
}

#cpu() {
#  load=$(ps -eo pcpu | awk 'BEGIN {sum=0.0f} {sum+=$1} END {printf "%.0f", sum}')
#  echo "%{F#504339}%{F-} $load%"
#}

#memory() {
#  mem=$(free --mega | grep Mem | awk '{print $3}')
#  echo "%{F#504339}%{F-} ${mem}m"
#}

volume() {
  # Gets volume level, 'off' if muted:
  vol=$(amixer get Master\
    | awk '/Mono.+/ {
      print $6=="[off]"?$6:$4
    }' | tr -d '[%]'
  )

  # Set the corresponding volume icon
  icon=""
  if [[ $vol == "off" || $vol -eq 0 ]]; then
    icon=""
    num=""
  elif [[ $vol -gt 0 && $vol -lt 30 ]]; then
    icon=""
  elif [[ $vol -ge 30 && $vol -lt 75 ]]; then
    icon=""
  elif [[ $vol -ge 50 ]]; then
    icon=""
  fi

  echo "$icon"
}

battery() {
  # Get the battery level (e.g. '74')
  bat=$(acpi -b | awk '{gsub(/%,/,""); print $4}' | sed 's/%//g')
  # Get the charging status (e.g. 'Discharging')
  status=$(acpi -b | awk '{gsub(/,/,""); print $3}')

  # Set the corresponding battery level or charging icon
  icon=""
  if [[ $status != "Discharging" ]]; then
    icon=""
  elif [[ $bat -lt 10 ]]; then
    icon=""
  elif [[ $bat -lt 40 ]]; then
    icon=""
  elif [[ $bat -lt 70 ]]; then
    icon=""
  else
    icon=""
  fi

  # TODO: Move to a function
  # Display a bar
  s="—"
  bar=""
  case $bat in
    100)
      if [[ $status != "Discharging" ]]; then
        bar=""
      else
        bar="$s$s$s$s$s$s$s$s$s"
      fi
      ;;
    [0-5])
      bar="%{F#D94016}$s%{F#504339}$s$s$s$s$s$s$s$s%{F-}"
      ;;
    [5-9])
      bar="%{F#D9A816}$s%{F#504339}$s$s$s$s$s$s$s$s%{F-}"
      ;;
    [1-2]*)
      bar="$s$s%{F#504339}$s$s$s$s$s$s$s%{F-}"
      ;;
    3*)
      bar="$s$s$s%{F#504339}$s$s$s$s$s$s%{F-}"
      ;;
    4*)
      bar="$s$s$s$s%{F#504339}$s$s$s$s$s%{F-}"
      ;;
    5*)
      bar="$s$s$s$s$s%{F#504339}$s$s$s$s%{F-}"
      ;;
    6*)
      bar="$s$s$s$s$s$s%{F#504339}$s$s$s%{F-}"
      ;;
    7*)
      bar="$s$s$s$s$s$s$s%{F#504339}$s$s%{F-}"
      ;;
    8*)
      bar="$s$s$s$s$s$s$s$s%{F#504339}$s%{F-}"
      ;;
    *)
      bar="$s$s$s$s$s$s$s$s$s"
      ;;
  esac

  echo "$icon $bar"
}

# TODO: Separate bar in two (Workpaces/Icons) for different refresh rates
while true; do
  echo "%{l}$(workspace) %{c}$(clock) %{r}%{B-} $(network) $(volume) $(battery) %{B-}"
  sleep .2;
done |
lemonbar -n bar-main -p -B#FF181512 -F#817267 -g 1600x20+0+0 \
-f 'tewi:pixelsize=10:antialias=true' -f 'siji:pixelsize=11' | bash

