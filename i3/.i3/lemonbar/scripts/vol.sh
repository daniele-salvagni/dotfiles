#!/bin/bash

# SYSTEM AUDIO
#
# Output format ([,],|,$ characters are not part of the output):
# VOL: %{volume:[0-100]}%%{status[on|off]}

# Get volume level [0-100]
volume=$(amixer get Master\
  | awk '/Mono.+/ {
    print $4
  }' | tr -d '[%]'
)

# Get the status (on if unmuted, off otherwise)
status=$(amixer get Master\
  | awk '/Mono.+/ {
    print $6
  }' | tr -d '[%]'
)

echo "VOL: %{volume:$volume}%%{status:$status}"

