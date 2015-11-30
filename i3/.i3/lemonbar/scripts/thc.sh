#!/bin/bash

# THERMAL CONTROL
#
# Output format ([,],|,$ characters are not part of the output):
# THC: %{profile:[silent|balanced|performance]}%

profile=$(cat /sys/devices/platform/sony-laptop/thermal_control)
echo "THC: %{profile:$profile}%"

