#!/bin/bash

cd '/etc/acme_tiny'

shopt -s extglob

# '!(account).key' matches everything that ends in .key, except account.key
for keyfile in !(account).key; do
  domain=${keyfile%.key}
  ./renew_cert.sh ${domain}
done
