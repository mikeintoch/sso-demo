#!/bin/sh
oc create -f sso70-image-stream.json
oc create -f sso70-postgresql-persistent.json

oc create -f eap70-image-stream.json
oc create -f eap70-sso-s2i.json
oc create -f eap70-https-s2i.json
