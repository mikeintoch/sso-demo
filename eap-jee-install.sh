#!/bin/sh

cd certs/

oc secrets new eap-jee-secret keystore.jks=jee-secure.dempsey-training2.apps.latest.xpaas.jks truststore.jks=truststore.jks jgroups.jceks=jgroups.jceks

cd ..

oc secrets add serviceaccount/eap-service-account secrets/eap-jee-secret

oc process eap70-sso-s2i \
  APPLICATION_NAME=jee \
  HOSTNAME_HTTP=jee.dempsey-training2.apps.latest.xpaas \
  HOSTNAME_HTTPS=jee-secure.dempsey-training2.apps.latest.xpaas \
  SOURCE_REPOSITORY_URL=https://github.com/maschmid/sso-demo.git \
  SOURCE_REPOSITORY_REF=master \
  CONTEXT_DIR=app-jee \
  ARTIFACT_DIR=target \
  HTTPS_SECRET=eap-jee-secret \
  HTTPS_KEYSTORE=keystore.jks \
  HTTPS_NAME=jee-secure.dempsey-training2.apps.latest.xpaas \
  HTTPS_PASSWORD=password \
  JGROUPS_ENCRYPT_SECRET=eap-jee-secret \
  JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks \
  JGROUPS_ENCRYPT_NAME=jgroups-key \
  JGROUPS_ENCRYPT_PASSWORD=password \
  SSO_URL=https://sso-secure.dempsey-training2.apps.latest.xpaas/auth \
  SSO_REALM=xpaas \
  SSO_USERNAME=mgmtuser \
  SSO_PASSWORD=mgmtpass \
  SSO_SAML_KEYSTORE_SECRET=eap-jee-secret \
  SSO_SAML_KEYSTORE="" \
  SSO_SAML_CERTIFICATE_NAME="" \
  SSO_SAML_KEYSTORE_PASSWORD="" \
  SSO_TRUSTSTORE=/etc/eap-secret-volume/truststore.jks \
  SSO_TRUSTSTORE_PASSWORD=password \
  SSO_TRUSTSTORE_SECRET=eap-jee-secret | oc create -f - 

oc env dc jee SERVICE_URL=https://jaxrs-secure.dempsey-training2.apps.latest.xpaas/service-jaxrs

