import 'dart:io';
import 'package:dio/dio.dart';
import 'package:personal_training_app/core/const/path_constants.dart';
import 'logger.dart';

class CountService {
  Future<Map<String, dynamic>?> getCountFromVideo(file, username) async {
    File f = File(file.path);
    String filePath = f.path;
    String fileName = 'exerciseVideo.mp4';
    const uri = "${PathConstants.videoServiceEndpoint}process";

    try {
      FormData formData = FormData.fromMap(<String, dynamic>{
        "video": await MultipartFile.fromFile(filePath, filename: fileName),
        "user": username
      });
      Response response = await Dio().post(uri, data: formData);
      logger.i("File upload response: $response");
      return response.data;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
