import 'package:flutter/material.dart';
import 'package:elements_detector/camera.dart';

class IpInput extends StatelessWidget {

  TextEditingController ipTextController = TextEditingController();
  TextEditingController portTextController = TextEditingController();

  IpInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: ipTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'IP Address',
            ),
          ),
          TextField(
            controller: portTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Port Number',
            ),
          ),
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              // Navigate to the camera screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraApp(
                    ip: ipTextController.text,
                    port: int.parse(portTextController.text),
                    )),
              );
            }
          ),
        ],
      ),
    );
  }
}