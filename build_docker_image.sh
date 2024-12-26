#!/bin/bash

# Set the image name and tag
IMAGE_NAME="deepstream-ultralytics"
TAG="latest"

# Display a message
echo "Building Docker image: $IMAGE_NAME:$TAG"

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Build the Docker image using the Dockerfile in the current directory
docker build -t "$IMAGE_NAME:$TAG" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Docker image built successfully: $IMAGE_NAME:$TAG"
else
    echo "Docker image build failed."
    exit 1
fi
