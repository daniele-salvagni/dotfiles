#!/usr/bin/env python3

""" Parse data from a Named Pipe to be displayed on lemonbar. """

import re, sys

# ===================================================================== SETTINGS

BG_COLOR = '982c2c'
FG_COLOR = 'b49f85'

# ====================================================================== METHODS

def levelBar(eColor, level):
  """ Create a text based level bar """
  line = "—"
  bar = ""
  eColor = "504339"

  if 0 <= level <= 5:
    bar = "%{F#D94016}" + line + "%{F#" + eColor + "}" + line*8 + "%{F-}"
  elif 5 < level <= 10:
    bar = "%{F#D9A816}" + line + "%{F#" + eColor + "}" + line*8 + "%{F-}"
  else:
    fullN = int(level/11)
    bar = line*(fullN) + "%{F#" + eColor + "}" + line*(9-fullN) + "%{F-}"

  return bar

# =================================================================== COMPONENTS

class Component:
  def __init__(self):
    raise NotImplementedError("Subclass must implement abstract method")
  def update(self, data):
    raise NotImplementedError("Subclass must implement abstract method")



class Bat(Component):
  """ BATTERY LEVEL """
  regExp = re.compile('.*%{level:(.*?)}%%{status:(.*?)}%.*')
  tag = 'BAT:'

  def __init__(self):
    """ Initialize some dummy data to be displayed if nothing has been read from
    the pipe
    """
    self.level = 0
    self.status = 'discharging'
    self.reParse()

  def update(self, data):
    """ Update the internal attributes from data """
    match = self.regExp.match(data)
    if match is not None:
      self.level = int(match.group(1))
      self.status = match.group(2)
      self.reParse()

  def reParse(self):
    """ Parse the data to be displayed on lemonbar """
    # Set the appropriate icon
    icon = ""
    if self.status != 'discharging':
      icon=""
    elif self.level < 10:
      icon=""
    elif self.level < 40:
      icon=""
    elif self.level < 70:
      icon=""
    else:
      icon=""

    # Add a levelBar (only if bat is discharging and not full)
    if self.status != 'discharging' and self.level == 100:
      bar = ''
    else:
      bar = levelBar('504339', self.level) + ' '

    # The parsed text that will be displayed
    self.parsed = icon + ' ' + bar

  def __str__(self):
    """ Return the parsed data """
    return self.parsed



class Dat(Component):
  """ TIME AND DATE """
  regExp = re.compile('.*%{timedate:(.*?)}%.*')
  tag = 'DAT:'

  def __init__(self):
    """ Initialize some dummy data to be displayed if nothing has been read from
    the pipe
    """
    self.timedate = 'Thu 01 Jan  00:00 AM'
    self.reParse()

  def update(self, data):
    """ Update the internal attributes from data """
    match = self.regExp.match(data)
    if match is not None:
      self.timedate = match.group(1)
      self.reParse()

  def reParse(self):
    """ Parse the data to be displayed on lemonbar """
    self.parsed = self.timedate

  def __str__(self):
    """ Return the parsed data """
    return self.parsed



class Net(Component):
  """ NETWORK CONNECTIVITY """
  regExp = re.compile('.*%{interface:(.*?)}%%{status:(.*?)}%.*')
  tag = 'NET:'

  def __init__(self):
    """ Initialize some dummy data to be displayed if nothing has been read from
    the pipe
    """
    self.interface = 'eth'
    self.status = 'disconnected'
    self.reParse()

  def update(self, data):
    """ Update the internal attributes from data """
    match = self.regExp.match(data)
    if match is not None:
      self.interface = match.group(1)
      self.status = match.group(2)
      self.reParse()

  def reParse(self):
    """ Parse the data to be displayed on lemonbar """
    # Set the appropriate icon
    icon = ''
    if self.interface == 'ethernet':
      icon=''
    elif self.interface == 'wifi' and self.status == 'disconnected':
      icon=''
    elif self.interface == 'wifi' and self.status == 'connected':
      icon=''

    # The parsed text that will be displayed
    self.parsed = icon

  def __str__(self):
    """ Return the parsed data """
    return self.parsed



class Thc(Component):
  """ THERMAL CONTROL """
  regExp = re.compile('.*%{profile:(.*?)}%.*')
  tag = 'THC:'

  def __init__(self):
    """ Initialize some dummy data to be displayed if nothing has been read from
    the pipe
    """
    self.profile = 'silent'
    self.reParse()

  def update(self, data):
    """ Update the internal attributes from data """
    match = self.regExp.match(data)
    if match is not None:
      self.profile = match.group(1)
      self.reParse()

  def reParse(self):
    """ Parse the data to be displayed on lemonbar """
    # Set the appropriate icon
    icon = ""
    if self.profile == 'silent':
      icon=''
    elif self.profile == 'balanced':
      icon=''
    elif self.profile == 'performance':
      icon=''

    # The parsed text that will be displayed
    self.parsed = '%{A:sh ~/.scripts/thermal-control.sh:}' + icon + '%{A}'

  def __str__(self):
    """ Return the parsed data """
    return self.parsed



class Vol(Component):
  """ SYSTEM AUDIO """
  regExp = re.compile('.*%{volume:(.*?)}%%{status:(.*?)}%.*')
  tag = 'VOL:'

  def __init__(self):
    """ Initialize some dummy data to be displayed if nothing has been read from
    the pipe
    """
    self.volume = 0
    self.status = 'off'
    self.reParse()

  def update(self, data):
    """ Update the internal attributes from data """
    match = self.regExp.match(data)
    if match is not None:
      self.volume = int(match.group(1))
      self.status = match.group(2)
      self.reParse()

  def reParse(self):
    """ Parse the data to be displayed on lemonbar """
    # Set the appropriate icon
    icon = ''
    if self.volume == 0 or self.status == 'off':
      icon=""
    elif self.volume < 30:
      icon=""
    elif self.volume < 75:
      icon=""
    else:
      icon=""

    # The parsed text that will be displayed
    self.parsed = icon

  def __str__(self):
    """ Return the parsed data """
    return self.parsed



class Wsp(Component):
  """ WORKSPACES """
  # Workspaces must be prefixed with a number followed by the '=' character,
  # like: 1=Workspace 1, 2=Workspace 2, ..., 10=Workspace 10
  # The prefix is needed for ordering purposes in i3 and will be stripped off
  # automatically in this script.

  # Bug: Does not work correctly for workspaces containing the ':' character,
  # it looks like it is messing with the event closing tag ':}', maybe a
  # lemonbar bug? (not tested)

  regExp = re.compile('.*%{workspaces:(.*?)}%.*')
  tag = 'WSP:'

  # Scrollwheel events (previous/next)
  wsnext="%{A4:i3-msg workspace next_on_output:}"
  wsprev="%{A5:i3-msg workspace prev_on_output:}"

  def __init__(self):
    """ Initialize some dummy data to be displayed if nothing has been read from
    the pipe
    """
    self.workspaces = ['-1=']
    self.reParse()

  def update(self, data):
    """ Update the internal attributes from data """
    match = self.regExp.match(data)
    if match is not None:
      wsdata = match.group(1)
      self.workspaces = wsdata[:-3].split('#%#') # Remove the last #%# separtor
      self.reParse()

  def reParse(self):
    """ Parse the data to be displayed on lemonbar """
    parsed = ''
    for ws in self.workspaces:
      if ws[0] == '*':
        parsed += '%{B#' + FG_COLOR + '}%{F#' + BG_COLOR + '} ' + ws[3:] + \
                  ' %{F-}%{B-}'
      else:
        parsed += '%{A:i3-msg workspace ' + ws[1:] + ':} ' + ws[3:] + ' %{A}'

    self.parsed = self.wsnext + self.wsprev + parsed + '%{A}%{A}'

  def __str__(self):
    """ Return the parsed data """
    return self.parsed

# ========================================================================= MAIN

def compose(comp):
  return '%{l}' + str(comp[5]) + '%{c}' + str(comp[1]) + '%{r}' + \
         str(comp[3]) + ' ' + str(comp[2]) + ' ' + str(comp[4]) + ' ' + \
         str(comp[0]) +  '%{B-}'


def main():
  components = [ Bat(), Dat(), Net(), Thc(), Vol(), Wsp() ]
  for line in sys.stdin:
    for component in components:
        if component.tag == line[:4]:
          component.update(line)
          print(compose(components))
          sys.stdout.flush()


if __name__ == "__main__":
  main()
