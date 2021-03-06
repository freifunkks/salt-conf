essential_pkgs:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - git
      - openssh-server
      - sudo
      - zsh
    - order: 1

admin:
  group.present:
    - system: True
    - order: 1

/etc/sudoers.d/admin:
  file.managed:
    - contents: '%admin ALL=(ALL:ALL) NOPASSWD:ALL'
    - user: root
    - group: root
    - mode: 640
    - makedirs: True
    - order: 1

ssh:
  service.running:
    - enable: True
    - order: 2

systemd-timesyncd:
  service.running:
    - enable: True

grml-etc-core:
  pkgrepo.managed:
    - name: deb http://deb.grml.org grml-stable main
    - humanname: fastd
    - dist: grml-stable
    - file: /etc/apt/sources.list.d/grml.list
    - refresh: True
    - keyid: 21E0CA38EA2EA4AB
    - keyserver: pgp.mit.edu
  pkg.installed:
    - require:
      - pkgrepo: grml-etc-core

/etc/zsh/zshrc.local:
  file.managed:
    - contents: |
        color='{{ pillar.minions[grains.id].zsh_host_color }}'
        zstyle ':prompt:grml:*:items:host' pre "%F{$color}"
        zstyle ':prompt:grml:*:items:path' pre '%B%f'
