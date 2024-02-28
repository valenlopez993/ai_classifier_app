import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';

mixin HttpCaller {

  Future<Map<String, dynamic>> post({required String url, required XFile file}) async{
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', 
        file.path,
        contentType: MediaType('image', 'jpeg'), // Adjust the content type as needed
      ),
    );

    try {
      http.StreamedResponse response = await request.send();
      var reqResponse = await http.Response.fromStream(response);

      var cacheFolder = await getApplicationCacheDirectory();
      List<FileSystemEntity> contents = cacheFolder.listSync();
      // Delete each file or subdirectory
      for (var fileOrDir in contents) {
        if (fileOrDir is File) {
          fileOrDir.deleteSync();
        } else if (fileOrDir is Directory) {
          fileOrDir.deleteSync(recursive: true);
        }
      }
      
      File file = File('${cacheFolder.path}/images.zip');
      await file.writeAsBytes(reqResponse.bodyBytes);

      var bytes = file.readAsBytesSync();
      var archive = ZipDecoder().decodeBytes(bytes);

      List<String> plotImages = [];
      List<String> filterImages = [];
      String category = '';
      String? objectLength;
      for (var file in archive) {
        var filename = file.name;
        String filePath = '${cacheFolder.path}/images/${DateTime.now()}/$filename';
        if (file.isFile) {
          const Utf8Decoder decoder = Utf8Decoder();
          if (filename.contains('category.txt')){
            category = decoder.convert(file.content);
          }
          else if (filename.contains('object_length.txt')){
            objectLength = decoder.convert(file.content);
            objectLength = objectLength == 'None' ? null : objectLength;
          }
          else{
            var outFile = File(filePath);
            outFile = await outFile.create(recursive: true);
            await outFile.writeAsBytes(file.content);
            if (outFile.path.contains('plot_')) {
              plotImages.add(outFile.path);
            }
            else {
              filterImages.add(outFile.path);
            }
          }
        }
      }

      return {
        'category': category,
        'objectLength': objectLength,
        'plotImages': plotImages,
        'filterImages': filterImages
        };

    }
    catch (e) {
      print('Error: $e'	);
      return {'Error': '$e'};
    }
  }
}