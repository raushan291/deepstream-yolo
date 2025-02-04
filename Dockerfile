# Use NVIDIA DeepStream 7.1 with Triton support as the base image
FROM nvcr.io/nvidia/deepstream:7.1-gc-triton-devel

# Set the working directory in the container
WORKDIR /workspace

# Copy everything from the DeepStream-Yolo to /workspace in the container
COPY DeepStream-Yolo/ /workspace/DeepStream-Yolo

# Clone the ultralytics repository & install ultralytics package and other dependencies
RUN git clone https://github.com/ultralytics/ultralytics.git && \
    cd ultralytics && \
    pip3 install -e . && \
    pip3 install onnx onnxslim onnxruntime

# Change into the cloned directory
WORKDIR /workspace/ultralytics

# Copy the export_yoloV8.py script from the utils directory to the ultralytics folder
RUN cp ../DeepStream-Yolo/utils/export_yoloV8.py .

# Download the YOLOv8 model weights file
RUN wget https://github.com/ultralytics/assets/releases/download/v8.2.0/yolov8n.pt

# Run the export script to generate the ONNX model
RUN python3 export_yoloV8.py -w yolov8n.pt --dynamic

# Copy the generated ONNX model and labels.txt file (if generated) to /workspace
RUN cp ./*.onnx  /workspace
RUN cp ./labels.txt  /workspace

# Open the workspace folder and compile the lib
WORKDIR /workspace/DeepStream-Yolo
RUN apt-get update && \
        apt-get install -y sudo && \
        sudo apt-get install -y \
        libvpx-dev \
        libflac-dev \
        libmp3lame-dev \
        libmpg123-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-tools \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstreamer-plugins-good1.0-dev \
        libgstreamer-plugins-bad1.0-dev \
        libglib2.0-dev \
        libboost-system-dev \
        libjson-glib-dev && \
    apt-get clean
RUN export CUDA_VER=12.6 && make -C nvdsinfer_custom_impl_Yolo clean && make -C nvdsinfer_custom_impl_Yolo

RUN cp ./nvdsinfer_custom_impl_Yolo/*.so ../
