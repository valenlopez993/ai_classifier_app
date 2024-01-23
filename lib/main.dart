import 'package:flutter/material.dart';
import 'package:elements_detector/camera.dart';

void main() {
  
  // Ensure that plugin services are initialized so that `availableCameras()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: CameraApp(),
  ));
}