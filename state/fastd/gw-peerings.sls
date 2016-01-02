include:
  - fastd

# Gateways that this gateway actively connects to
{% for peer in pillar['fastd_peerings'][grains['id']] %}
/etc/fastd/ffks_vpn/gateways/{{ peer }}:
  file.managed:
    - contents: |-
        key "{{ pillar['minions'][peer]['fastd_public'] }}";
        remote "{{ peer }}.de" port 10000;
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: fastd
    - watch_in:
      - service: fastd@ffks_vpn
{% endfor %}

# Gateways that are allowed to connect to this gateway
{% for minion, peers in pillar['fastd_peerings'].items() %}
  {% if peers.count(grains['id']) > 0 %}
/etc/fastd/ffks_vpn/gateways/{{ minion }}:
  file.managed:
    - contents: |-
        key "{{ pillar['minions'][minion]['fastd_public'] }}";
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: fastd
    - watch_in:
      - service: fastd@ffks_vpn
  {% endif %}
{% endfor %}

https://github.com/freifunkks/fastd-keys.git:
  git.latest:
    - target: /etc/fastd/ffks_vpn/nodes
    - force_reset: True
    - user: root
    - require:
      - pkg: fastd
    - watch_in:
      - service: fastd@ffks_vpn
