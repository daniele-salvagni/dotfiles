#!/bin/bash

# Iterate to the next thermal profile after every execution
# Silent -> Balanced -> Performance -> Silent

state=$(cat /sys/devices/platform/sony-laptop/thermal_control)

if [[ "$state" == "silent" ]]; then
  exec tee /sys/devices/platform/sony-laptop/thermal_control <<< 'balanced'
elif [[ "$state" == "balanced" ]]; then
  exec tee /sys/devices/platform/sony-laptop/thermal_control <<< 'performance'
else
  exec tee /sys/devices/platform/sony-laptop/thermal_control <<< 'silent'
fi
