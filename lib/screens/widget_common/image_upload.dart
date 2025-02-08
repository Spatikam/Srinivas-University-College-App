import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CloudinaryService {
  Future<String?> uploadImage(File imageFile) async {
    final String cloudName = "dzqmpdyet";
    final String uploadPreset = "rip_skillan";

    final Uri uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url']; // Image URL
    } else {
      return null;
    }
  }

  static extractPublicId(String imageUrl) {
    Uri uri = Uri.parse(imageUrl);
    String path = uri.pathSegments.last; // Extract last part of the URL
    return path.split('.').first; // Remove file extension
  }

  static Future<bool> deleteImage(String publicId) async {
    final response = await http.post(
      Uri.parse(
          "https://su-g8x4ba5wn-rip-skillans-projects.vercel.app/api/delete-image"),
      body: jsonEncode({"publicId": publicId}),
      headers: {"Content-Type": "application/json"},
    );
    print("response: ${response.reasonPhrase}");

    return response.statusCode == 200;
  }


  Future<File> compressImage(File file) async {
    final directory = await getTemporaryDirectory();
    final targetPath = path.join(directory.path, 'compressed.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 10, // Adjust quality (0-100)
    );

    return File(result!.path);
     
  }

  /*static Future<bool> deleteImage(String imagepath) async {
    final String cloudName = "dzqmpdyet";
    final String apiKey = "634447443194529";
    final String publicId = imagepath;
    final String apiUrl =
        "https://api.cloudinary.com/v1_1/$cloudName/image/destroy";

    var response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "public_id": publicId,
        "api_key": apiKey,
        "timestamp": (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString(),
        // A secure signature is needed for production
      },
    );

    return response.statusCode == 200;
  }*/
}
