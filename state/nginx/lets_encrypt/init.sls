acme_tiny:
  user.present:
    - shell: /bin/bash
    - createhome: False
    - order: 11

# Will fail if /home/acme exists, but won't delete it
exit 1:
  cmd.run:
    - onlyif: test -e /home/acme_tiny

/etc/sudoers.d/reload_nginx:
  file.managed:
    - contents: 'acme_tiny ALL=(root) NOPASSWD:/bin/systemctl reload nginx'
    - user: root
    - group: root
    - mode: 640

# Directory with all the keys, certificate requests and certificates!
/etc/acme_tiny:
  file.directory:
    - mode: 700
    - user: acme_tiny
    - group: acme_tiny

# Document root for .well-known/acme-challenge/
/srv/http/challenges:
  file.directory:
    - mode: 755
    - user: acme_tiny
    - group: acme_tiny

# Actual acme-tiny script
https://github.com/diafygi/acme-tiny.git:
  git.latest:
    - target: /opt/acme-tiny
    - user: root
    # ^ Should be readable and executable by acme_tiny, but not writable

# Previous comment applies to these scripts as well
/etc/acme_tiny/renew_cert.sh:
  file.managed:
    - source: salt://nginx/lets_encrypt/renew_cert.sh
    - user: root
    - group: root
    - mode: 755

/etc/acme_tiny/renew_all_certs.sh:
  file.managed:
    - source: salt://nginx/lets_encrypt/renew_all_certs.sh
    - user: root
    - group: root
    - mode: 755
  cron.present:
    - identifier: renew-lets-encrypt-certs
    - user: acme_tiny
    - minute: 42
    - hour: 1
    - daymonth: 19
    # ^ Some random time once a month, because the 'default' of the first day of the
    #   month at 00:00 probably has enough requests coming in on the Let's Encrypt server.
