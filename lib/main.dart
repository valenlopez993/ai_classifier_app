import 'package:ai_classifier/ip_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  // Ensure that plugin services are initialized so that `availableCameras()`
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: IpInput(),
  ));
}