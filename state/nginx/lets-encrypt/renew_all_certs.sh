#!/bin/bash

[[ "$pwd" = "/etc/acme_tiny" ]] || exit 1

for keyfile in *.key; do
  domain=${keyfile%.key}
  ./renew_cert.sh ${domain}
done
