#!/bin/sh

oc process eap70-https-s2i \
  APPLICATION_NAME=profile \
  HOSTNAME_HTTPS=profile-secure.dempsey-training2.apps.latest.xpaas \
  SOURCE_REPOSITORY_URL=https://github.com/maschmid/sso-demo.git \
  SOURCE_REPOSITORY_REF=master \
  CONTEXT_DIR=app-profile-jee-saml \
  HTTPS_SECRET=eap-profile-secret \
  HTTPS_KEYSTORE=keystore.jks \
  HTTPS_NAME=profile-secure \
  HTTPS_PASSWORD=password \
  JGROUPS_ENCRYPT_SECRET=eap-profile-secret \
  JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks \
  JGROUPS_ENCRYPT_NAME=jgroups-key \
  JGROUPS_ENCRYPT_PASSWORD=password \
  | oc create -f - 


