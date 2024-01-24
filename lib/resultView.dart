import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ResultView extends StatefulWidget {

  final List<String> images; 
  final String category;

  const ResultView({
    super.key,
    required this.images,
    required this.category
    });

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            widget.category.toUpperCase(),
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold
            )
          )),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
        children: List.generate(widget.images.length, (index) {
          String imgPath = widget.images[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20
            ),
            child: Column(
              children: [
                Text(
                  basenameWithoutExtension(imgPath),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Image.file(
                  File(imgPath)
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}