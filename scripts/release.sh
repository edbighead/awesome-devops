#!/bin/bash

cd ../app

IMAGE_VERSION=""
IMAGE_NAME="edbighead/go-app"

if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "Example usage:"
  echo "release.sh -v 1.0"
  echo ""
  echo "-v [mandatory]: docker image version"
else
  while getopts h:v: option; do
    case "${option}" in
    v) IMAGE_VERSION=${OPTARG} ;;
    esac
  done
  

  if [ "$IMAGE_VERSION" = "" ]; then
    echo "Version should be specified. Please see --help"
    exit -1
  fi

  IMAGE="$IMAGE_NAME:$IMAGE_VERSION"
  echo "building $IMAGE"

  docker build --build-arg app_version=$IMAGE_VERSION -t $IMAGE .
  docker push $IMAGE
  
fi