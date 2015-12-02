#!/usr/bin/python

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




match = bat['regExp'].match(line)
match.group(0)

def parseFifo(line):
  if line.startswith(bat["tag"]):
    print("bat")
  elif line.startswith(dat["tag"]):
    pass
  elif line.startswith(net["tag"]):
    pass
  elif line.startswith(thc["tag"]):
    print("thc")
  elif line.startswith(vol["tag"]):
    pass
  elif line.startswith(wsp["tag"]):
    pass
  else:
    # Invalid string, do nothing
    pass

with open("/tmp/myPipe") as fifo:
  for line in fifo:
    parseFifo(line)

