#!/bin/sh

oc create serviceaccount sso-service-account

cd certs/

./certs.sh
oc secrets new sso-secret keystore.jks=sso-secure.dempsey-training2.apps.latest.xpaas.jks truststore.jks=truststore.jks jgroups.jceks=jgroups.jceks

cd ..

oc secrets add serviceaccount/sso-service-account secrets/sso-secret

oc create -f sso70-image-stream.json
oc create -f sso70-postgresql-persistent.json
oc import-image redhat-sso70-openshift

oc policy add-role-to-user view system:serviceaccount:dempsey-training2:sso-service-account

oc process sso70-postgresql-persistent \
  HOSTNAME_HTTPS=sso-secure.dempsey-training2.apps.latest.xpaas\
  HTTPS_NAME=sso-secure.dempsey-training2.apps.latest.xpaas\
  HTTPS_SECRET=sso-secret\
  HTTPS_KEYSTORE=keystore.jks\
  HTTPS_PASSWORD=password\
  JGROUPS_ENCRYPT_SECRET=sso-secret\
  JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks\
  JGROUPS_ENCRYPT_PASSWORD=password\
  JGROUPS_ENCRYPT_NAME=jgroups-key\
  SSO_REALM=xpaas\
  SSO_SERVICE_USERNAME=mgmtuser\
  SSO_SERVICE_PASSWORD=mgmtpass\
  SSO_TRUSTSTORE=/etc/eap-secret-volume/truststore.jks\
  SSO_TRUSTSTORE_PASSWORD=password\
  SSO_TRUSTSTORE_SECRET=sso-secret | oc create -f - 


