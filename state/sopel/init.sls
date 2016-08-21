sopel:
  user.present:
    - shell: /usr/sbin/nologin
  pkg.installed:
    - name: enchant
  pip.installed:
    - require:
      - pip: backports.ssl_match_hostname
      - pkg: python-pip
      - pkg: enchant

backports.ssl_match_hostname:
  pip.installed:
    - require:
      - pkg: python-pip
