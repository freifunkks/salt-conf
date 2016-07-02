tunneldigger:
  pkg.installed:
    - pkgs:
      - bridge-utils
      - ebtables
      - iproute
      - libevent-dev
      - libnetfilter-conntrack3
      - python-dev
      - python-virtualenv
  user.present:
    - shell: /usr/sbin/nologin
  git.latest:
    - name: https://github.com/wlanslovenija/tunneldigger.git
    - target: /home/tunneldigger/tunneldigger
    - rev: v0.2.0
    - user: tunneldigger
    - require:
      - pkg: tunneldigger
      - user: tunneldigger

/home/tunneldigger/tunneldigger/virtualenv:
  virtualenv.managed:
    - requirements: /home/tunneldigger/tunneldigger/broker/requirements.txt
    - user: tunneldigger
    - require:
        - git: tunneldigger

/var/log/tunneldigger:
  file.directory:
    - user: tunneldigger
    - mode: 755

/home/tunneldigger/hooks/up.sh:
  file.managed:
    - source: salt://tunneldigger/up.sh
    - makedirs: True
    - user: tunneldigger

/home/tunneldigger/hooks/pre-down.sh:
  file.managed:
    - source: salt://tunneldigger/pre-down.sh
    - makedirs: True
    - user: tunneldigger

/home/tunneldigger/hooks/mtu-changed.sh:
  file.managed:
    - source: salt://tunneldigger/mtu-changed.sh
    - makedirs: True
    - user: tunneldigger

/home/tunneldigger/hooks/bridge-functions.sh:
  file.managed:
    - source: salt://tunneldigger/bridge-functions.sh
    - makedirs: True
    - user: tunneldigger
