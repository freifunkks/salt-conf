/home/buildsrv/check-git-and-build.sh:
  file.managed:
    - source: salt://buildsrv/check-git-and-build.sh
    - user: sopel
    - group: sopel
    - mode: 755
    - require:
      - file: /home/buildsrv

/home/buildsrv:
  file.directory:
    - user: sopel
    - group: sopel
    - mode: 755

buildsrv_pkgs:
  pkg.installed:
    - pkgs:
      - build-essential
      - gawk
      - git
      - libncurses-dev
      - libssl-dev
      - libz-dev
      - subversion
      - unzip
