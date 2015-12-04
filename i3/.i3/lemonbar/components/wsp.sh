#!/bin/bash

# WORKSPACES
#
# Output format:
# WSP: %{workspaces:%[-1Ws1]%%[*2Ws2]%}%

while :
do

  # Put the output of wmctrl on one line, lines will be separated by '#%#'
  workspaces=$(wmctrl -d | awk '{print $2 substr($0, index($0,$9))}' ORS='#%#')

  # Note: to put it back on multiple lines | awk '{print $0}' RS='#%#'

  echo "WSP:%{workspaces:$workspaces}%"

sleep .2s
done

