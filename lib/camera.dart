import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:elements_detector/httpCaller.dart';

class CameraApp extends StatefulWidget with HttpCaller{

  final String ip;
  final int port;
  
  CameraApp({
    super.key,
    required this.ip,
    required this.port
  });

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
  void initState() async {
    super.initState();
    await initializeCamera();
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

  void takePicture() async {
    final image = await _controller!.takePicture();
    
    final response = await widget.post(
      url: 'http://${widget.ip}:${widget.port}/knn_classifier', 
      file: image
    );

    setState(() {
      category = response;
    });
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
            onPressed: takePicture,
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
