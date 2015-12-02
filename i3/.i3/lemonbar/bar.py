#!/usr/bin/python

import re

bat = { 'tag': "BAT:", 'level': "", 'status': "" }
dat = { 'tag': "DAT:", 'timedate': "" }
net = { 'tag': "NET:", 'interface': "", 'status': "" }
thc = { 'tag': "THC:", 'profile': "" }
vol = { 'tag': "VOL:", 'volume': "", 'status': "" }
wsp = { 'tag': "WSP:", 'workspaces': "" }

bat['regExp'] = re.compile(".*%{level:(.*?)}%%{status:(.*?)}%.*")
dat['regExp'] = re.compile(".*%{timedate:(.*?)}%.*")
net['regExp'] = re.compile(".*%{interface:(.*?)}%%{status:(.*?)}%.*")
thc['regExp'] = re.compile(".*%{profile:(.*?)}%.*")
vol['regExp'] = re.compile(".*%{volume:(.*?)}%%{status:(.*?)}%.*")
wsp['regExp'] = re.compile(".*%{workspaces:(.*?)}%.*")


def parseFifo(line):
  # Battery Level
  if line.startswith(bat["tag"]):
    match = bat['regExp'].match(line)
    if match is not None:
      bat['level'] = match.group(0)
      bat['status'] = match.group(1)
  # Time and Date
  elif line.startswith(dat["tag"]):
    match = dat['regExp'].match(line)
    if match is not None:
      dat['timedate'] = match.group(0)
  # Network Connection
  elif line.startswith(net["tag"]):
    match = net['regExp'].match(line)
    if match is not None:
      net['interface'] = match.group(0)
      net['status'] = match.group(1)
  # Thermal Control
  elif line.startswith(thc["tag"]):
    match = bat['regExp'].match(line)
    if match is not None:
      bat['profile'] = match.group(0)
  # System Volume
  elif line.startswith(vol["tag"]):
    match = vol['regExp'].match(line)
    if match is not None:
      vol['volume'] = match.group(0)
      bat['status'] = match.group(1)
  # Workspaces
  elif line.startswith(wsp["tag"]):
    match = wsp['regExp'].match(line)
    if match is not None:
      wsp['workspaces'] = match.group(0)
  else:
    pass



with open("/tmp/myPipe") as fifo:
  for line in fifo:
    parseFifo(line)

