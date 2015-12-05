flx:
  user.present:
    - home: /home/flx
    - shell: /usr/bin/zsh
    - groups:
      - admin
  ssh_auth.present:
    - user: flx
    # curl "https://api.github.com/users/icks/keys" | jshon -a -e key -u
    - source: salt://common/users/flx.ssh_auth_keys
