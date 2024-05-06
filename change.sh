#!/bin/bash

# Check if service name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

SERVICE_NAME=$1

# Build the Docker image
docker build  -t bugramatik/rs-$SERVICE_NAME:latest $SERVICE_NAME/

# Push the Docker image to the registry
docker push bugramatik/rs-$SERVICE_NAME:latest

# Wait for 3 seconds after pushing the image
sleep 3

helm delete my-release

# Helm upgrade command to set the repo and pull policy, and upgrade the release
helm install my-release --set image.repo=docker.io/bugramatik,image.pullPolicy=Always K8s/helm/
