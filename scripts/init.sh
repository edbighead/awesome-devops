#!/bin/bash

# Connect to Kubernetes cluster
gcloud container clusters get-credentials my-gke-cluster --zone us-east1-b --project awesome-devops

# Install Tiller
helm init --wait --service-account tiller

# Install influxdb
helm install stable/influxdb --wait --name influxdb --namespace monitoring --set persistence.enabled=true,persistence.size=10Gi
kubectl exec -i -t --namespace monitoring $(kubectl get pods --namespace monitoring -l app=influxdb -o jsonpath='{.items[0].metadata.name}')  -- influx -execute 'create database response'

# kubectl port-forward --namespace monitoring $(kubectl get pods --namespace monitoring -l app=influxdb -o jsonpath='{ .items[0].metadata.name }') 8086:8086

helm upgrade go-app-live --install --wait --namespace application --set image.tag=1.0 --set fullnameOverride=go-app-live ../helm/go-app
helm upgrade go-app-canary --install --wait --namespace application --set image.tag=2.0 --set fullnameOverride=go-app-canary ../helm/go-app
