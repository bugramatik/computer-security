#!/bin/bash

# Define your Docker Hub username
DOCKER_HUB_USERNAME="localhost:5000"

# List all directories containing a Dockerfile
services="payment cart catalogue dispatch fluentd load-gen mongo mysql ratings shipping user web"

# Loop through each service and process the Dockerfiles
for service in $services; do
  echo "Processing service: $service"

  # Navigate into the service directory
  cd $service

  # Check if Dockerfile exists
  if [ -f Dockerfile ]; then
    # Build the Docker image
    docker build -t $DOCKER_HUB_USERNAME/rs-$service:latest .
    build_status=$?

    if [ $build_status -eq 0 ]; then
      echo "Build successful. Pushing $service image..."
      # Push the Docker image to Docker Hub
      docker push $DOCKER_HUB_USERNAME/rs-$service:latest
      push_status=$?

      if [ $push_status -ne 0 ]; then
        echo "Failed to push $service image. Exiting..."
        exit 1
      fi
    else
      echo "Build failed for $service. Exiting..."
      exit 1
    fi
  else
    echo "No Dockerfile found in $service directory. Skipping..."
  fi

  # Navigate back to the root directory
  cd ..
done

echo "All services have been processed."
