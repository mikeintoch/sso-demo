#!/bin/sh

oc process eap70-sso-s2i \
  APPLICATION_NAME=jaxrs \
  HOSTNAME_HTTPS=jaxrs-secure.dempsey-training2.apps.latest.xpaas \
  SOURCE_REPOSITORY_URL=https://github.com/maschmid/sso-demo.git \
  SOURCE_REPOSITORY_REF=master \
  CONTEXT_DIR=service-jaxrs \
  ARTIFACT_DIR=target \
  HTTPS_SECRET=eap-jaxrs-secret \
  HTTPS_KEYSTORE=keystore.jks \
  HTTPS_NAME=jaxrs-secure \
  HTTPS_PASSWORD=password \
  JGROUPS_ENCRYPT_SECRET=eap-jaxrs-secret \
  JGROUPS_ENCRYPT_KEYSTORE=jgroups.jceks \
  JGROUPS_ENCRYPT_NAME=jgroups-key \
  JGROUPS_ENCRYPT_PASSWORD=password \
  SSO_SAML_KEYSTORE_SECRET=eap-jaxrs-secret \
  SSO_SAML_KEYSTORE="" \
  SSO_SAML_CERTIFICATE_NAME="" \
  SSO_SAML_KEYSTORE_PASSWORD="" \
  SSO_URL=https://sso-secure.dempsey-training2.apps.latest.xpaas/auth \
  SSO_REALM=xpaas \
  SSO_USERNAME=mgmtuser \
  SSO_PASSWORD=mgmtpass \
  SSO_BEARER_ONLY=true \
  SSO_ENABLE_CORS=true \
  SSO_TRUSTSTORE=/etc/eap-secret-volume/truststore.jks \
  SSO_TRUSTSTORE_PASSWORD=password \
  SSO_TRUSTSTORE_SECRET=eap-jaxrs-secret | oc create -f - 

