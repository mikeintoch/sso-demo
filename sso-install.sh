#!/bin/sh

oc process sso70-postgresql-persistent \
  HOSTNAME_HTTPS=sso-secure.sso-training-demo.192.168.42.198.nip.io \
  HTTPS_NAME=sso-secure \
  HTTPS_SECRET=sso-secret \
  HTTPS_KEYSTORE=keystore.jks \
  HTTPS_PASSWORD=password \
  JGROUPS_ENCRYPT_SECRET=sso-secret \
  JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks \
  JGROUPS_ENCRYPT_PASSWORD=password \
  JGROUPS_ENCRYPT_NAME=jgroups-key \
  SSO_REALM=xpaas \
  SSO_SERVICE_USERNAME=mgmtuser \
  SSO_SERVICE_PASSWORD=mgmtpass \
  SSO_TRUSTSTORE=/etc/eap-secret-volume/truststore.jks \
  SSO_TRUSTSTORE_PASSWORD=password \
  SSO_TRUSTSTORE_SECRET=sso-secret | oc create -f - 


