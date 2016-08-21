sopel:
  user.present:
    - shell: /usr/sbin/nologin
  pip.installed:
    - require:
      - pkg:
        - python-pip
        - backports.ssl_match_hostname

backports.ssl_match_hostname:
  pip.installed:
    - require:
      - pkg: python-pip
