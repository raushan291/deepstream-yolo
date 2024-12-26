# DeepStream-Yolo Setup Guide

### Clone the **DeepStream-Yolo** repository:

```bash
git clone https://github.com/marcoslucianops/DeepStream-Yolo.git
cd DeepStream-Yolo
```
##

### Edit the config_infer_primary_yoloV8 file

Edit the `config_infer_primary_yoloV8.txt` file according to your model (example for YOLOv8s with 80 classes)

```
[property]
...
onnx-file=yolov8s.pt.onnx
...
num-detected-classes=80
...
parse-bbox-func-name=NvDsInferParseYolo
...
```

**NOTE**: The **YOLOv8** resizes the input with center padding. To get better accuracy, use

```
[property]
...
maintain-aspect-ratio=1
symmetric-padding=1
...
```

##

### Edit the deepstream_app_config file

```
...
[primary-gie]
...
config-file=config_infer_primary_yoloV8.txt
```

##

### Build the Docker Image & Run the Docker Container

To begin, navigate to the base directory of this repository.

1. **Build the Docker Image**: To build the Docker image, execute the following script:

```bash
build_docker_image.sh
```

2. **Run the Docker Container**: After the image is built, start the Docker container by running the following script:

```bash
run_docker_container.sh
```

##

### Testing the model

```
deepstream-app -c deepstream_app_config.txt
```

### Testing the sample model

```
deepstream-app -c /opt/nvidia/deepstream/deepstream-7.1/samples/configs/deepstream-app/source30_1080p_dec_infer-resnet_tiled_display_int8.txt
```

##

### Troubleshooting
**Note**: Although the Docker container will contain ONNX files, if the ONNX file is not present, navigate to the `/workspace/ultralytics` directory and generate the ONNX file using the following command:

```bash
python3 export_yoloV8.py -w yolov8n.pt --dynamic
```
Afterward, copy the generated ONNX model and labels.txt file (if generated) to the /workspace directory:

```bash
cp ./*.onnx  /workspace/
cp ./labels.txt  /workspace/
```
