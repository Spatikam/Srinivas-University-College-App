import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class PythonAnywhereService {
  final String baseUrl = "http://webflowserver.pythonanywhere.com"; // Change this!

  // ✅ Upload Image to PythonAnywhere
  Future<String?> uploadImage(File imageFile, String institute) async {
    final Uri uri = Uri.parse("$baseUrl/upload/$institute");

    // Compress Image Before Uploading
    File compressedImage = await compressImage(imageFile);

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', compressedImage.path));
    request.headers.addAll({"X-API-KEY": "887a88ba-1a25-4e2d-bf4a-748e4a835694"});

    var response = await request.send();
    if (response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse['filename']; // Return the uploaded filename
    } else {
      print("YOU FAILED TO UPLOAD");
      return null;
    }
  }

  // ✅ Fetch Image URL from PythonAnywhere
  String getImageUrl(String institute, String filename) {
    return "$baseUrl/fetch/$institute/$filename";
  }

  // ✅ Delete Image from PythonAnywhere
  Future<bool> deleteImage(String institute, String filename) async {
    log("$baseUrl/delete/$institute/$filename");
    final Uri uri = Uri.parse("$baseUrl/delete/$institute/$filename");
    var request = http.Request('DELETE', uri);

    request.headers.addAll({"X-API-KEY": "887a88ba-1a25-4e2d-bf4a-748e4a835694"});

    var response = await request.send();

    var responseData = await response.stream.bytesToString();
    log(responseData);

    if (response.statusCode == 200) {
      print("✅ Image deleted successfully.");
      return true;
    } else {
      print("❌ Failed to delete image.");
      return false;
    }
  }

  // ✅ Compress Image Before Uploading

  Future<File> compressImage(File file) async {
    final directory = await getTemporaryDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final targetPath = path.join(directory.path, '$fileName.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90, // Adjust quality (0-100)
    );

    return File(result!.path);
  }

  Future<bool> requestStoragePermission() async {
    PermissionStatus statusStorage;
    PermissionStatus statusPhotos;

    if (await Permission.storage.isGranted || await Permission.photos.isGranted) {
      return true;
    }

    statusStorage = await Permission.storage.request();
    statusPhotos = await Permission.photos.request();

    if (statusStorage.isDenied && statusPhotos.isDenied) {
      return false;
    }

    if (statusStorage.isPermanentlyDenied || statusPhotos.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return statusStorage.isGranted || statusPhotos.isGranted; 
  }
}
