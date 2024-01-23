import 'package:elements_detector/ipInput.dart';
import 'package:flutter/material.dart';

void main() {

  // Ensure that plugin services are initialized so that `availableCameras()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: IpInput(),
  ));
}