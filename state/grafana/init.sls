apt-transport-https: pkg.installed

grafana:
  pkgrepo.managed:
    - name: deb https://packagecloud.io/grafana/stable/debian/ jessie main
    - humanname: grafana
    - dist: jessie
    - file: /etc/apt/sources.list.d/grafana.list
    - refresh_db: true
    - key_url: https://packagecloud.io/gpg.key
    - require:
      - pkg: apt-transport-https
  pkg.installed:
    - require:
      - pkgrepo: grafana
  service.running:
    - name: grafana-server
    - enable: True
    - watch:
      - pkg: grafana
