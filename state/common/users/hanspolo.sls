hanspolo:
  user.present:
    - home: /home/hanspolo
    - shell: /usr/bin/zsh
    - groups:
      - admin
  ssh_auth.present:
    - user: hanspolo
    # curl "https://api.github.com/users/hanspolo/keys" | jshon -a -e key -u
    - source: salt://common/users/hanspolo.ssh_auth_keys
