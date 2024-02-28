import 'dart:io';
import 'package:ai_classifier/plots_result_view.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FiltersResultView extends StatefulWidget {

  final List<String> filterImages;
  final List<String> plotImages;
  final String category;
  final String? objectLength;

  const FiltersResultView({
    super.key,
    required this.filterImages,
    required this.plotImages,
    required this.category,
    this.objectLength
    });

  @override
  State<FiltersResultView> createState() => _FiltersResultViewState();
}

class _FiltersResultViewState extends State<FiltersResultView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: Center(
          child: Column(
            children: [
              Text(
                widget.category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                )
              ),
              if (widget.objectLength != null)
                Text(
                  'Longitud: ${widget.objectLength}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                )
            ],
          )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
          children: List.generate(widget.filterImages.length, (index) {
            String imgPath = widget.filterImages[index];
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlotsResultView(
                plotImages: widget.plotImages,
                category: widget.category,
                objectLength: widget.objectLength,
              )
            )
          ),
          child: const Text(
            'Plots',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20
            ),
          ),
        ),
      ),
    );
  }
}