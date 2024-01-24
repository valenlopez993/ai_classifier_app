import 'package:flutter/material.dart';
import 'package:elements_detector/camera.dart';

class IpInput extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController ipTextController = TextEditingController();
  final TextEditingController portTextController = TextEditingController();

  final double paddingSize = 10.0;

  void onSubmitPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Navigate to the camera screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraApp(
            ip: ipTextController.text,
            port: int.parse(portTextController.text),
            )),
      );
    }
  }

  IpInput({super.key});

  String? ipValitation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid IP address';
    }
    return null;
  }

  String? portValitation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid port number';
    }
    else if (int.tryParse(value) == null) {
      return 'Port number must be an integer';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(paddingSize),
                  child: TextFormField(
                    controller: ipTextController,
                    validator: ipValitation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'IP Address',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(paddingSize),
                  child: TextFormField(
                    controller: portTextController,
                    validator: portValitation,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Port Number',
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () => onSubmitPressed(context)
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}