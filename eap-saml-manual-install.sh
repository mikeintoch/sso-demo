#!/bin/sh

cd certs/

oc secrets new eap-app-secret keystore.jks=saml-secure.dempsey-training2.apps.latest.xpaas.jks truststore.jks=truststore.jks jgroups.jceks=jgroups.jceks

cd ..

oc create -f eap70-https-s2i.json

oc secrets add serviceaccount/eap-service-account secrets/eap-app-secret

oc process eap70-https-s2i \
  APPLICATION_NAME=saml \
  HOSTNAME_HTTP=saml.dempsey-training2.apps.latest.xpaas \
  HOSTNAME_HTTPS=saml-secure.dempsey-training2.apps.latest.xpaas \
  SOURCE_REPOSITORY_URL=https://github.com/maschmid/sso-demo.git \
  SOURCE_REPOSITORY_REF=master \
  CONTEXT_DIR=app-profile-jee-saml \
  HTTPS_SECRET=eap-app-secret \
  HTTPS_KEYSTORE=keystore.jks \
  HTTPS_NAME=saml-secure.dempsey-training2.apps.latest.xpaas \
  HTTPS_PASSWORD=password \
  JGROUPS_ENCRYPT_SECRET=eap-app-secret \
  JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks \
  JGROUPS_ENCRYPT_NAME=jgroups-key \
  JGROUPS_ENCRYPT_PASSWORD=password \
  | oc create -f - 


