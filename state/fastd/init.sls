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

/etc/fastd/ffks-vpn/fastd.conf:
  file.managed:
    - source: salt://fastd/ffks-vpn.conf
    - template: jinja
    - user: root
    - owner: root
    - mode: 600
    - makedirs: True
    - require:
      - pkg: fastd

/etc/fastd/peers:
  file.directory:
    - user: root
    - owner: root
    - mode: 755
    - require:
      - pkg: fastd

# Peers that this minion connects to
{% for peer in pillar['fastd_peerings'][grains['id']] %}
/etc/fastd/peers/{{ peer }}:
  file.managed:
    - contents: |-
        key "{{ pillar['minions'][peer]['fastd_public'] }}";
        remote "{{ peer }}.de" port 10000;
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: fastd
{% endfor %}

# Peers that are allowed to connect to this minion
{% for minion, peers in pillar['fastd_peerings'].items() %}
  {% if peers.count(grains['id']) > 0 %}
/etc/fastd/peers/{{ minion }}:
  file.managed:
    - contents: |-
        key "{{ pillar['minions'][minion]['fastd_public'] }}";
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: fastd
  {% endif %}
{% endfor %}
