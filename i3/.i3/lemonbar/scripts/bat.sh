#!/bin/bash

# BATTERY POWER
#
# Output format ([,],|,$ characters are not part of the output):
# BAT: %{status:[charging|discharging|full]}%%{level:[0-100]}%

while :
do

  # Get the battery level (e.g. '74')
  level=$(acpi -b | awk '{gsub(/%,/,""); print $4}' | sed 's/%//g')
  # Get the charging status (e.g. 'discharging')
  status=$(acpi -b | awk '{gsub(/,/,""); print tolower($3)}')

  echo "BAT: %{level:$level}%%{status:$status}%"

sleep 1s
done

