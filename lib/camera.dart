import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:elements_detector/httpCaller.dart';
import 'package:http/http.dart';

class CameraApp extends StatefulWidget with HttpCaller{
  CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  
  CameraController? _controller;
  List<CameraDescription>? cameras;

  String category = '';

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    // Select the first camera from the list

    CameraController controller = CameraController(cameras![0], ResolutionPreset.medium);

    // Initialize the camera controller
    await controller.initialize();

    // Set the camera controller in the state
    setState(() {
      _controller = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget buildCameraPreview() {
  if (!_controller!.value.isInitialized) {
    return Container();
  }
  return AspectRatio(
    aspectRatio: _controller!.value.aspectRatio,
    child: CameraPreview(_controller!),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(category)),
      ),
      body: Column(
        children: [
          Expanded(child: buildCameraPreview()),
          FloatingActionButton(
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {

                // Attempt to take a picture and then get the location
                // where the image file is saved.
                final image = await _controller!.takePicture();
                
                final response = await widget.post(
                  url: 'http://192.168.100.19:5000/knn_classifier', 
                  file: image
                );

                print('Here: $response');

                setState(() {
                  category = response;
                });

              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
