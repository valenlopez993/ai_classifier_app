import 'package:flutter/material.dart';
import 'package:ai_classifier/camera.dart';

class IpInput extends StatefulWidget {

  IpInput({super.key});

  @override
  State<IpInput> createState() => _IpInputState();
}

class _IpInputState extends State<IpInput> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController ipTextController = TextEditingController();

  final TextEditingController portTextController = TextEditingController();

  final Map<String, String> methods = {
    'KNN': 'knn_classifier',
    'K Means': 'kmeans_classifier'
  };

  String? _selectedItem;

  final double paddingSize = 10.0;

  void onSubmitPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Navigate to the camera screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraApp(
            method: methods[_selectedItem]!,
            ip: ipTextController.text,
            port: int.parse(portTextController.text),
            )),
      );
    }
  }

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
    _selectedItem = _selectedItem ?? methods.keys.first;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text('Algoritmo:'),
              ),
              DropdownButton<String>(
                value: _selectedItem,
                items: methods.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedItem = value!;
                  });
                },
              ),
            ],
          ),
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