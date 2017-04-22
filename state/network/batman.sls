/etc/network/interfaces.d/bat0:
  file.managed:
    - source: salt://network/bat0
    - template: jinja

/etc/iproute2/rt_tables:
  file.managed:
    - source: salt://network/rt_tables

batman_adv:
  kmod.present:
    - persist: True
