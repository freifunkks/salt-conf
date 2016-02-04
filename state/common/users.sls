{% for user in pillar['users'] %}
{{ user }}:
  user.present:
    - home: /home/{{ user }}
    - shell: /usr/bin/zsh
    - groups:
      - admin

/home/{{ user }}/.ssh/authorized_keys:
  file.managed:
    - contents_pillar: users:{{ user }}:ssh_auth_keys
    - user: {{ user }}
    - group: {{ user }}
    - mode: 600
    - makedirs: True
    - dir_mode: 700
{% endfor %}

# Command to get ssh keys from GitHub (requires jshon and curl):
# curl "https://api.github.com/users/GITHUB_USERNAME/keys" | jshon -a -e key -u
