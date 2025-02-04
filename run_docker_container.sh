#!/bin/bash

DOCKER_IMAGE="deepstream-ultralytics:latest"
CONTAINER_NAME="deepstream"

# Remove any existing container with the same name
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  echo "Removing existing container with name: $CONTAINER_NAME"
  docker rm -f $CONTAINER_NAME
fi

# Ensure X11 forwarding is enabled
export DISPLAY=${DISPLAY:-:0}
xhost +local:docker > /dev/null

# Run the Docker container with GUI support
docker run --gpus all -it \
    --net=host \
    --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
    --runtime=nvidia \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    -v $PWD/DeepStream-Yolo:/workspace/DeepStream-Yolo \
    --name $CONTAINER_NAME \
    $DOCKER_IMAGE

# Copy necessary files
# cp ../ultralytics/export_yoloV8.py .
# cp ../ultralytics/*.onnx .
# cp ../ultralytics/labels.txt .
# cp ../libnvdsinfer_custom_impl_Yolo.so ./nvdsinfer_custom_impl_Yolo
