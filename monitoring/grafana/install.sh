#!/bin/bash

NAMESPACE=monitoring

# Create datasource configmap
kubectl apply -f datasourceConfigmap.yaml --namespace $NAMESPACE

# Create dashboard configmap
kubectl apply -f dashboardConfigmap.yaml --namespace $NAMESPACE

# Install grafana release
helm upgrade grafana --install stable/grafana --version 2.3.3 -f values.yaml --wait --namespace $NAMESPACE

# Create ingress controller 
kubectl apply -f grafanaIngress.yaml --namespace $NAMESPACE

# Get admin password
echo "ADMIN PASSWORD:"
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo