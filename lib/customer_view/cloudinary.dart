import 'dart:io';
import 'package:dio/dio.dart';

class CloudinaryService {
  final String cloudName = "dpufywjjt"; // Replace with your Cloudinary Cloud Name
  final String uploadPreset = "flutter_upload"; // Replace with your Upload Preset

  Future<String?> uploadImage(File imageFile) async {
    try {
      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path),
        "upload_preset": uploadPreset,
      });

      Dio dio = Dio();
      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data["secure_url"];
      } else {
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
