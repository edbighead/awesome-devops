#!/bin/bash

RELEASE_NAME=""
IMAGE_TAG=""
NAMESPACE="application"
CHART_NAME="amweek/go-app"

if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Example usage:"
  echo "install.sh -n go-app-prod -v 1.0"
  echo ""
  echo "-n [mandatory]: name of the release"
  echo "-v [mandatory]: docker image tag"
else
  while getopts h:v:n: option; do
    case "${option}" in
    v) IMAGE_TAG=${OPTARG} ;;
    n) RELEASE_NAME=${OPTARG} ;;
    esac
  done
  

  if [ "$IMAGE_TAG" = "" ]; then
    echo "Version should be specified. Please see --help"
    exit -1
  fi

  if [ "$RELEASE_NAME" = "" ]; then
    echo "Release name should be specified. Please see --help"
    exit -1
  fi

  helm upgrade $RELEASE_NAME --install  --namespace $NAMESPACE --set image.tag=$IMAGE_TAG --set fullnameOverride=$RELEASE_NAME --wait $CHART_NAME
fi