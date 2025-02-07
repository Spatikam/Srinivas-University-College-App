import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class CloudflareService {
  Future<String?> uploadImage(File imageFile) async {
    final String cloudName = "dzqmpdyet"; 
    final String uploadPreset = "rip_skillan"; 

    final Uri uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url']; // Image URL
    } else {
      return null;
    }
  }
}
