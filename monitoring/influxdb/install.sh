#!/bin/bash

NAMESPACE=monitoring

# Install influxdb chart
helm install stable/influxdb --wait --name influxdb --namespace $NAMESPACE --version 1.1.3

kubectl exec -i -t --namespace monitoring $(kubectl get pods --namespace monitoring -l app=influxdb -o jsonpath='{.items[0].metadata.name}')  \
-- influx -execute 'create database response'