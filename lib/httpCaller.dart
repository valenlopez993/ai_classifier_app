import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

mixin HttpCaller {

  Future<String> post({required String url, required XFile file}) async{

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', 
        file.path,
        contentType: MediaType('image', 'jpeg'), // Adjust the content type as needed
      ),
    );
    
    http.StreamedResponse response = await request.send();
    final jsonResponse = await http.Response.fromStream(response);
    return json.decode(jsonResponse.body)['category'];
  }

  Future<String> get({required String url}) async{
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

}