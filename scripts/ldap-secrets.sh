#!/bin/bash
set -euxo pipefail

#
# Configures the LDAP secret engine using OpenLDAP
#


# Check for required env vars
: "$VAULT_ADDR"
: "$VAULT_TOKEN"


# Root rotation logs are written to the server log at DEBUG level
# Ensure they get written to stdout
vault write sys/loggers/rotation-job-manager level=debug


# ignore errors upon re-run
vault secrets enable ldap 2>/dev/null | true

# Rotates root credential every 5 minutes
# See docker-compose.yml for OpenLDAP server config
vault write ldap/config \
    rotation_schedule="*/5 * * * *" \
    binddn="cn=admin,dc=example,dc=com" \
    bindpass="admin" \
    url="ldap://ldap-server:389"

vault write -f ldap/rotate-root


# Query ldap server to read password hash and confirm it changes
# docker compose exec ldap-server ldapsearch -b "cn=admin,dc=example,dc=com" -D "cn=admin,dc=example,dc=com" -w admin  
