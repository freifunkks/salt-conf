gitlab-ce:
  pkgrepo.managed:
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/debian/ jessie main
    - humanname: gitlab
    - dist: jessie
    - file: /etc/apt/sources.list.d/gitlab.list
    - refresh_db: true
    - key_url: https://packagecloud.io/gpg.key
    - clean_file: True
  pkg.installed:
    - require:
      - pkgrepo: gitlab-ce
