sopel:
  user.present:
    - shell: /usr/sbin/nologin
  pkg.installed:
    - name: enchant
  pip.installed:
    - require:
      - pip: backports.ssl_match_hostname
      - pkg: python-pip
      - pkg: enchant

backports.ssl_match_hostname:
  pip.installed:
    - require:
      - pkg: python-pip

/usr/share/ca-certificates/hackint/rootca.crt:
  file.managed:
    - source: salt://sopel/hackint-rootca.crt
    - makedirs: True

/etc/ssl/certs/Hackint_IRC_Network_Root_CA.pem:
  file.symlink:
    - target: /usr/share/ca-certificates/hackint/rootca.crt

/home/sopel/.sopel/default.cfg:
  file.managed:
    - source: salt://sopel/sopel.cfg
    - template: jinja
    - makedirs: True

https://github.com/freifunkks/sopel-modules.git:
  git.latest:
    - target: /home/sopel/.sopel/modules
    - user: sopel
