#!/bin/bash

# TIME AND DATE
#
# Output format ([,],|,$ characters are not part of the output):
# DAT: %{timedate:$timedate}%

while :
do

  timedate=$(date '+%a %d %b %l:%M %p')
  echo "DAT:%{timedate:$timedate}%"

# Wait for the next minute change
sleep $(( 61 - $(date '+%S') ))
done

