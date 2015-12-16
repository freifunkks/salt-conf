fastd:
  pkgrepo.managed:
    - name: deb http://repo.universe-factory.net/debian/ sid main
    - humanname: fastd
    - dist: sid
    - file: /etc/apt/sources.list.d/fastd.list
    - refresh_db: true
    - keyid: CB201D9C
    - keyserver: pgp.mit.edu
  pkg.installed:
    - require:
      - pkgrepo: fastd

tools:
  pkg.installed:
    - pkgs:
      - curl
      - dstat
      - gdb
      - htop
      - iputils-tracepath
      - iotop
      - mg # Mini-Emacs
      - mtr
      - tcpdump
      - tmux
      - vim
      - vnstat
      - vnstati
      - wget
