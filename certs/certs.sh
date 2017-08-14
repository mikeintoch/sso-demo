#!/bin/sh

# cleanup
rm *.cer *.csr *.jks *.jceks *.pem *.srl

# Generate the symmetric key for jgroups
keytool -genseckey -keyalg AES -keysize 256 -alias jgroups-key -keystore jgroups.jceks -storetype JCEKS -storepass "password" -keypass "password"

# prepare CA key and cert
openssl req -new -newkey rsa:4096 -x509 -keyout ca-key.pem -out ca-certificate.pem -days 365 -passout pass:password -subj "/C=CZ/ST=CZ/L=Brno/O=QE/CN=xpaas.ca"

# Import CA cert as "truststore"
keytool -import -noprompt -keystore truststore.jks -file ca-certificate.pem -alias xpaas.ca -storepass "password"

suffix=sso-training-demo.192.168.42.198.nip.io

for appname in sso-secure jaxrs-secure jee-secure profile-secure
do
  CN=${appname}.${suffix}
  keystore=${appname}.jks
  
  # Create a keystore with new keypair for a given CN
  keytool -genkeypair -keyalg RSA -noprompt -alias ${appname} -dname "CN=${CN}, OU=QE, O=RedHat, L=Brno, S=CZ, C=CZ" -keystore ${keystore} -storepass "password" -keypass "password"

  # Generate a certificate request
  keytool -keystore ${keystore} -certreq -alias ${appname} --keyalg rsa -file ${CN}".csr" -storepass "password"

  # Sign the certificate request with the CA cert
  openssl x509 -req -CA ca-certificate.pem -CAkey ca-key.pem -in ${CN}.csr -out ${CN}.cer -days 365 -CAcreateserial -passin "pass:password"

  # Import CA cert into keystore
  keytool -import -noprompt -keystore ${keystore} -file ca-certificate.pem -alias xpaas.ca -storepass "password"

  # Import signed cert  into keystore
  keytool -import -keystore ${keystore} -file ${CN}".cer" -alias ${appname} -storepass "password"
done
