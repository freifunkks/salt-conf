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
    - target: /srv/tunneldigger
    - rev: v0.2.0
    - user: tunneldigger
    - require:
      - pkg: tunneldigger
      - user: tunneldigger

/srv/tunneldigger:
  virtualenv.managed:
    - requirements: /srv/tunneldigger/broker/requirements.txt
    - user: tunneldigger
    - require:
        - git: tunneldigger
