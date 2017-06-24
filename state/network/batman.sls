# bat0 interface is managed within fastd

/etc/iproute2/rt_tables:
  file.managed:
    - source: salt://network/rt_tables

batman_adv:
  kmod.present:
    - persist: True
