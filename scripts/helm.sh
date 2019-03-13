#!/bin/bash

cd ../helm/go-app
helm package .
/c/gcloud/google-cloud-sdk/bin/gsutil.cmd cp gs://awesome-devops-helm-charts/index.yaml .
helm repo index --merge index.yaml --url https://awesome-devops-helm-charts.storage.googleapis.com .
cat index.yaml
/c/gcloud/google-cloud-sdk/bin/gsutil.cmd cp index.yaml *.tgz gs://awesome-devops-helm-charts

rm index.yaml *.tgz