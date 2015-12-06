jplatte:
  user.present:
    - home: /home/jplatte
    - shell: /usr/bin/zsh
  ssh_auth.present:
    - user: jplatte
    # curl "https://api.github.com/users/jplatte/keys" | jshon -a -e key -u
    - source: salt://common/users/jplatte.ssh_auth_keys
