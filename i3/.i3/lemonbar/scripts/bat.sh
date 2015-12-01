#!/bin/bash

# BATTERY POWER
#
# Output format ([,],|,$ characters are not part of the output):
# BAT: %{status:[charging|discharging|full]}%%{level:[0-100]}%

while :
do

  # Get the charging status (e.g. 'discharging')
  status=$(acpi -b | awk '{gsub(/,/,""); print tolower($3)}')
  # Get the battery level (e.g. '74')
  level=$(acpi -b | awk '{gsub(/%,/,""); print $4}' | sed 's/%//g')

  echo "BAT: %{status:$status}%%{level:$level}%"

sleep 1s
done

