#!/bin/bash

domain=$1

# Request signed cert - Account and certificate request creation are not automated,
#   the account.key and csr files have to be present before running this script
python /opt/acme-tiny/acme_tiny.py \
  --account-key /etc/acme_tiny/account.key \
  --csr         /etc/acme_tiny/${domain}.csr \
  --acme-dir    /srv/http/challenges/ \
  > /etc/acme_tiny/${domain}.crt \
  || exit

# Download intermediate certificate
wget -qO /etc/acme_tiny/intermediate.pem \
  https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem

# Combine both into the full certificate chain
cat \
  /etc/acme_tiny/${domain}.crt \
  /etc/acme_tiny/intermediate.pem \
  > /etc/acme_tiny/${domain}.pem

# Have nginx reload the certificate file
service nginx reload
