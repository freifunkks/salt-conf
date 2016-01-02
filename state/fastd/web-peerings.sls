include:
  - fastd

{% for minion, data in pillar['minions'].items() %}
  {% if data.gateway %}
/etc/fastd/ffks_vpn/gateways/{{ minion }}:
  file.managed:
    - contents: |-
        key "{{ data['fastd_public'] }}";
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: fastd
    - watch_in:
      - service: fastd@ffks_vpn
  {% endif %}
{% endfor %}
