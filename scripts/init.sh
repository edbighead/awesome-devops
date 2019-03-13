#!/bin/bash

# Connect to Kubernetes cluster
gcloud container clusters get-credentials my-gke-cluster --zone us-east1-b --project awesome-devops
/c/gcloud/google-cloud-sdk/bin/gsutil.cmd setmeta -R -h 'Cache-Control:public, max-age=0, no-transform' gs://awesome-devops-helm-charts/index.yaml
# Install Tiller
helm init --service-account tiller
sleep 10

# Initialize 
helm repo add devops-charts https://awesome-devops-helm-charts.storage.googleapis.com

# Install influxdb
helm install stable/influxdb --wait --name influxdb --namespace monitoring --set persistence.enabled=true,persistence.size=10Gi
kubectl exec -i -t --namespace monitoring $(kubectl get pods --namespace monitoring -l app=influxdb -o jsonpath='{.items[0].metadata.name}')  -- influx -execute 'create database response'

helm install stable/traefik --name my-release --namespace kube-system 
# kubectl port-forward --namespace monitoring $(kubectl get pods --namespace monitoring -l app=influxdb -o jsonpath='{ .items[0].metadata.name }') 8086:8086