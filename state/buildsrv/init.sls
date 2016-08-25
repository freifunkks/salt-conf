/home/buildsrv/check-git-and-build.sh:
  file.managed:
    - source: salt://buildsrv/check-git-and-build.sh
    - user: sopel
    - group: sopel

/home/buildsrv:
  file.directory:
    - user: sopel
    - group: sopel
    - mode: 755
