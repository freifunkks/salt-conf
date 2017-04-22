https://github.com/freifunk-darmstadt/respondder.git:
  git.latest:
    - target: /opt/respondder

/etc/systemd/system/respondder.service:
  file.managed:
    - source: salt://respondder/respondder.service
    - user: root
    - group: root
    - mode: 644

respondder_deps:
   pkg.latest:
     - pkgs:
       - ethtool
       - lsb-release

respondder:
  service.running:
    - enable: True
    - require:
      - git: https://github.com/freifunk-darmstadt/respondder.git
      - file: /etc/systemd/system/respondder.service
      - pkg: respondder_deps
