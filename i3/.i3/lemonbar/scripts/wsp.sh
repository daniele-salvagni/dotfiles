#!/bin/bash

# WORKSPACES
#
# Output format ([,],|,$ characters are not part of the output):
# WSP: %{workspaces:$wmctrl-output}%

# Put the output of wmctrl on one line, lines will be separated by '-%-'
workspaces=$(wmctrl -d | awk '{print $0}' ORS='-%-')

# Note: to put it back on multiple lines | awk '{print $0}' RS='-%-'

echo "WSP: %{workspaces:$workspaces}%"

