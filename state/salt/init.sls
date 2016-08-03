/etc/salt/minion:
  file.managed:
    - source: salt://salt/minion
    - mode: 644
    - makedirs: True
