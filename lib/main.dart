import 'package:flutter/material.dart';
import 'package:elements_detector/camera.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: CameraApp(),
  ));
}