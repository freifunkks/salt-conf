fastd-repo:
  pkgrepo.managed:
    - name: deb http://repo.universe-factory.net/debian/ sid main
    - humanname: fastd
    - dist: sid
    - file: /etc/apt/sources.list.d/fastd.list
    - refresh_db: true

tools:
  pkg.installed:
    - pkgs:
      - curl
      - dstat
      - fastd
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
