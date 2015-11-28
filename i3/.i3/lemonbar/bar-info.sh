#!/bin/bash

thermal() {
  # Need write permissions for /sys/devices/platform/sony-laptop/thermal_control
  tc=$(cat /sys/devices/platform/sony-laptop/thermal_control)

  icon=""
  case $tc in
    "silent")
      icon=""
      ;;
    "balanced")
      icon=""
      ;;
    "performance")
      icon=""
      ;;
  esac

  echo "$icon"
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
  ping -c 1 8.8.8.8 >/dev/null 2>&1 && status="conn" || status="disc"

  icon=""
  if [[ $int == "ETH" ]]; then
    icon=""
  elif [[ $int == "WiFi" && $status == "disc" ]]; then
    icon=""
  elif [[ $int == "WiFi" && $status == "conn" ]]; then
    icon=""
  fi

  echo "$icon"
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


while :; do
  echo "%{B-}%{r}$(thermal) $(network) $(volume) $(battery) %{B-}"
  sleep .5s;
done |
lemonbar -d -n bar-info -B#181512 -F#817267 -g 730x20+870+0 \
-f 'tewi:pixelsize=10:antialias=true' -f 'siji:pixelsize=11' | bash

