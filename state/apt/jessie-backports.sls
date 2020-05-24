# Based on
# https://unix.stackexchange.com/a/508728

jessie-backports:
  pkgrepo.managed:
    - name: deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main
    - humanname: jessie-backports
    - dist: jessie
    - file: /etc/apt/sources.list.d/jessie-backports.list
    - refresh: True

/etc/apt/apt.conf.d/90check-valid-until:
  file.managed:
    - contents: Acquire::Check-Valid-Until "false";
