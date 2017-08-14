#!/bin/sh

namespace=sso-demo-training

# Create the service account
oc create serviceaccount sso-service-account
oc create serviceaccount eap-service-account

cd certs/

# Generate the keystore / truststores
./certs.sh

# Create secrets from the keystores
oc secrets new sso-secret keystore.jks=sso-secure.jks truststore.jks=truststore.jks jgroups.jceks=jgroups.jceks
oc secrets new eap-jaxrs-secret keystore.jks=jaxrs-secure.jks truststore.jks=truststore.jks jgroups.jceks=jgroups.jceks
oc secrets new eap-jee-secret keystore.jks=jee-secure.jks truststore.jks=truststore.jks jgroups.jceks=jgroups.jceks
oc secrets new eap-profile-secret keystore.jks=profile-secure.jks truststore.jks=truststore.jks jgroups.jceks=jgroups.jceks

# Add secrets to the service accounts
oc secrets add serviceaccount/sso-service-account secrets/sso-secret
oc secrets add serviceaccount/eap-service-account secrets/eap-jaxrs-secret
oc secrets add serviceaccount/eap-service-account secrets/eap-jee-secret
oc secrets add serviceaccount/eap-service-account secrets/eap-profile-secret

# Add view role to the service accounts (for kubeping clustering)
oc policy add-role-to-user view system:serviceaccount:${namespace}:sso-service-account
oc policy add-role-to-user view system:serviceaccount:${namespace}:eap-service-account


