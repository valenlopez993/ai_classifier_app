import 'package:elements_detector/resultView.dart';
import 'package:elements_detector/wait_view.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:elements_detector/httpCaller.dart';

class CameraApp extends StatefulWidget with HttpCaller{

  final String ip;
  final int port;
  final String method;
  
  CameraApp({
    super.key,
    required this.method,
    required this.ip,
    required this.port
  });

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  
  final _pageController = PageController(initialPage: 0, keepPage: true);
  CameraController? _controller;
  List<CameraDescription>? cameras;

  final _cameraAspectRatio = 3/4;

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    // Select the first camera from the list

    CameraController controller = CameraController(cameras![0], ResolutionPreset.ultraHigh);

    // Initialize the camera controller
    await controller.initialize();

    controller.setFlashMode(FlashMode.off);
    controller.setFocusMode(FocusMode.auto);

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
    // if (!_controller!.value.isInitialized) {
    //   return Container();
    // }
    // return AspectRatio(
    //   aspectRatio: 1/_cameraAspectRatio,
    //   child: CameraPreview(_controller!),
    // );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / _cameraAspectRatio,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: AspectRatio(
                  aspectRatio: 1/_controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                )),
          ),
        )),
    );
  }

  void takePicture() async {

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );

    final image = await _controller!.takePicture();

    final response = await widget.post(
      url: 'http://${widget.ip}:${widget.port}/${widget.method}', 
      file: image
    );

    if (response.containsKey('Error')) {
      SnackBar(
        content: Text('Error: ${response['Error']}'),
      );
        _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultView(
          images: response['images'],
          category: response['category'],
          objectLength: response['objectLength'],
        )
      )
    );

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  GestureDetector(
                    onTapDown: (position) {
                      _controller!.setFocusMode(FocusMode.locked);
                      double x = position.localPosition.dx / MediaQuery.of(context).size.width;
                      double y = position.localPosition.dy / (MediaQuery.of(context).size.width / _cameraAspectRatio);
                      _controller!.setFocusPoint(Offset(x, y));
                    },
                    child: _controller != null ? buildCameraPreview() : Container()
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: FloatingActionButton(
                      onPressed: takePicture,
                      backgroundColor: Colors.lightBlueAccent,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const WaitView()
      ]
    );
  }
}
