#!/bin/bash

cd ../app
docker build --build-arg app_version=3.0 -t edbighead/go-app:3.0 .
docker push edbighead/go-app:3.0