/home/buildsrv/check-git-and-build.sh:
  file.managed:
    - source: salt://buildsrv/check-git-and-build.sh
    - user: buildsrv
    - group: buildsrv
    - mode: 755
    - require:
      - user: buildsrv

buildsrv:
  user.present

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
