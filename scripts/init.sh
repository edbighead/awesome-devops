#!/bin/bash

# Connect to Kubernetes cluster
gcloud container clusters get-credentials my-gke-cluster --zone us-east1-b --project awesome-devops

# Install Tiller
helm init --wait --service-account tiller

helm upgrade --install traefik stable/traefik --version 1.64.0 -f values-traefik.yaml --wait