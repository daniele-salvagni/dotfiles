#!/bin/bash

# NETWORK CONNECTIVITY
# Notes: It is assumed that if ethernet is UP, then it has priority over wifi.
#
# Output format ([,],|,$ characters are not part of the output):
# NET: %{interface:[wifi|eth]}%%{status:[connected|disconnected]}%

while :
do

  # The following assumes the existence of 3 interfaces: loopback, ethernet, wifi
  read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
   
  # The 'iwconfig' command succeeds only if the interface tested has a wireless
  # extension, otherwise it will just return an error in STDERR: 'no wireless 
  # extension'
  if iwconfig $int1 >/dev/null 2>&1; then
    wifi=$int1 # command succeded, int1 has a wireless extension
    eth0=$int2
  else
    wifi=$int2
    eth0=$int1
  fi

  # This line will set the variable $int to 'eth' if it's up, 'wifi' otherwise.
  ip link show $eth0 | grep 'state UP' >/dev/null && int="eth" || int="wifi"

  # Send a single packet, to speed up the test. (Google DNS: 8.8.8.8)
  ping -c 1 8.8.8.8 >/dev/null 2>&1 && status="connected" || status="disconnected"

  echo "NET:%{interface:$int}%%{status:$status}%"

sleep 5s
done

