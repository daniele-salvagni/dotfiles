#!/bin/bash

# TIME AND DATE
#
# Output format ([,],|,$ characters are not part of the output):
# DAT: %{timedate:$timedate}%

timedate=$(date '+%a %d %b %l:%M %p')
echo "DAT: %{timedate:$timedate}%"

