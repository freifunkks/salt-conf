{% import_yaml 'minions.yml' as minions %}

base:
  '*':
    - fastd
    - minions
    - userdata

  {% if minions[grains['id']].gateway %}
    - gw-schedule
  {% endif %}

  excalipurr.ffks:
    - grafana
