#!/bin/bash

#
# Script developed to create some portfowards from k8s to local environment
# To run this script we need to call: $ source script.sh
#

CONTEXT=
NAME_SPACE=

POD1=
POD1_PORT=5010

POD2=
POD2_PORT=5020

POD3=
POD3_PORT=5030

POD4=
POD4_PORT=5040

POD5=
POD5_PORT=5050

kubectl config use-context $CONTEXT

POD1=$(kubectl get pods -o=name -n $NAME_SPACE | grep -m 1 "$POD1" | sed 's/^.*\///')
POD2=$(kubectl get pods -o=name -n $NAME_SPACE | grep -m 1 "$POD2" | sed 's/^.*\///')
POD3=$(kubectl get pods -o=name -n $NAME_SPACE | grep -m 1 "$POD3" | sed 's/^.*\///')
POD4=$(kubectl get pods -o=name -n $NAME_SPACE | grep -m 1 "$POD4" | sed 's/^.*\///')
POD5=$(kubectl get pods -o=name -n $NAME_SPACE | grep -m 1 "$POD5" | sed 's/^.*\///')

kubectl port-forward $POD1 $POD1_PORT:8080 -n $NAME_SPACE &
kubectl port-forward $POD2 $POD2_PORT:8080 -n $NAME_SPACE &
kubectl port-forward $POD3 $POD3_PORT:8080 -n $NAME_SPACE &
kubectl port-forward $POD4 $POD4_PORT:8080 -n $NAME_SPACE &
kubectl port-forward $POD5 $POD5_PORT:8080 -n $NAME_SPACE
