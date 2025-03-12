
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Helpers {


  static Future<FilePickerResult> convertUint8ListToFilePickerResult(Uint8List imageBytes, int size) async {
    final tempFile = await _writeToTempFile(imageBytes);

    return FilePickerResult([PlatformFile(path: tempFile.path, name: 'image.jpg_${size}', size: size)]);
  }

  static Future<File> _writeToTempFile(Uint8List bytes) async {

    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');

    await tempFile.writeAsBytes(bytes);

    return tempFile;
  }


  static Future<Uint8List?> cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );

    if (croppedFile != null) {
      return await File(croppedFile.path).readAsBytes();
    } else {
      return null; // croppedFile이 null인 경우 null 반환
    }
  }


  static Future<String> getMemberId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("memberId") ?? '';
  }


  static Future<void> setNotificationIsView(bool notificationIsView) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("notificationIsView", notificationIsView);
  }

  static Future<bool> getNotificationIsView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notificationIsView") ?? false;
  }

  static String getCategory(int trackCategoryId){

    if (trackCategoryId == 1) {
      return "K-pop";
    } else if (trackCategoryId == 2) {
      return "힙합";
    } else if (trackCategoryId == 3) {
      return "발라드";
    } else if (trackCategoryId == 4) {
      return "락";
    } else if (trackCategoryId == 5) {
      return "디제잉";
    } else if (trackCategoryId == 6) {
      return "알엔비";
    }
    return "장르 없음";
  }



  static Future<dynamic> apiCall(
      String url, {
        String method = 'GET',  // 기본값 'GET'
        Map<String, String>? headers,  // 요청 헤더 (optional)
        Map<String, dynamic>? body,    // 요청 바디 (optional)
        List<http.MultipartFile?>? fileList, // 파일 첨부 (optional)
      }) async {
    try {
      print('공통 API 호출 : ' + url);

      var uri = Uri.parse(dotenv.get('API_URL') + url);
      var request;

      final storage = FlutterSecureStorage();
      String? jwtToken = await storage.read(key: "jwt_token");
      // 기본 헤더에 accessToken 추가
      if (jwtToken != null) {
        headers ??= {};  // headers가 null인 경우 빈 맵으로 초기화
        if(!url.startsWith("/auth/")){
          headers['Authorization'] = 'Bearer $jwtToken';  // 액세스 토큰을 Authorization 헤더에 추가
        }
      }

      if (method == 'POST') {
        // POST 요청 처리
        if (fileList != null && fileList.length != 0) {


          // 파일이 있는 경우 Multipart 요청 사용
          request = http.MultipartRequest('POST', uri)
            ..headers.addAll(headers ?? {});

          for (http.MultipartFile? fileItem in fileList) {
            request.files.add(fileItem);
          }


          // 바디 추가
          if (body != null) {
            body.forEach((key, value) {
              request.fields[key] = value;
            });
          }

        } else {
          // 바디가 있는 일반 POST 요청 처리
          request = http.Request('POST', uri)
            ..headers.addAll(headers ?? {})
            ..body = json.encode(body);


        }
        // POST 요청 보내기
        var response = await request.send();
        var httpResponse = await http.Response.fromStream(response);
        if (httpResponse.body.isEmpty) {
          print('response 데이터 없음');
          return null; // 빈 본문 처리
        }
        return await _processResponse(httpResponse);

      } else if (method == 'GET') {
        // GET 요청 처리
        var response = await http.get(uri, headers: headers);
        return await _processResponse(response);

      } else {
        throw Exception('Unsupported HTTP method');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return null;
    }
  }

  // 응답 처리 (공통 처리)
  static Future<dynamic> _processResponse(http.Response response) async {
    if (response.statusCode == 200) {
      // 성공적인 응답 처리
      final decodedBody = utf8.decode(response.bodyBytes);
      return json.decode(decodedBody);
    } else {
      // 오류 처리
      print('Failed request with status: ${response.statusCode}');
      return null;
    }
  }


}
