
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/fcm/auth_service.dart';
import 'package:skrrskrr/model/comn/upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:skrrskrr/prov/auth_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/router/app_router_config.dart';

import '../main.dart';

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

  static bool getIsAuth(String checkMemberId, String loginMemberId)  {
    return checkMemberId == loginMemberId;
  }

  static Future<String> getMemberId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("memberId") ?? '';
  }

  // static Future<void> pickImage(dynamic model, bool isMemberImage, BuildContext context) async {
  //
  //
  //   Upload upload = Upload();
  //   if (isMemberImage) {
  //     upload.memberId = model.memberId;
  //   } else {
  //     upload.trackId = model.trackId;
  //   }
  //
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image, // 이미지 파일만 선택
  //   );
  //
  //   if (result != null && result.files.isNotEmpty) {
  //     _imageBytes = await Helpers.cropImage(result.files.first.path!);
  //
  //     FilePickerResult filePickerResult =
  //     await Helpers.convertUint8ListToFilePickerResult(_imageBytes!, result.files.first.size);
  //
  //     upload.uploadImage = filePickerResult;
  //     upload.uploadImageNm = result.files.first.name ?? "";
  //
  //     if(newImagePath != ""){
  //       if (isMemberImage) {
  //         String newImagePath = await Provider.of<ImageProv>(context).updateMemberImage(upload);
  //         model.memberImagePath = newImagePath;
  //       } else {
  //         String newImagePath = await Provider.of<ImageProv>(context).updateTrackImage(upload);
  //         model.trackImagePath = newImagePath;
  //       }
  //     }
  //
  //
  //   }
  // }

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
      return "HipHop";
    } else if (trackCategoryId == 3) {
      return "Ballad";
    } else if (trackCategoryId == 4) {
      return "Rock";
    } else if (trackCategoryId == 5) {
      return "Dj";
    } else if (trackCategoryId == 6) {
      return "R&B";
    }
    return "All";
  }




  static Future<http.MultipartFile?> fnSetUploadAudioFile(Upload upload, serverFileNm) async {

    File file = File(upload.uploadFile!.files.first.path.toString());
    List<int> fileBytes = await file.readAsBytes();

    // 바이트 배열을 멀티파트 파일로 추가
    return http.MultipartFile.fromBytes(
      serverFileNm, // 서버에서 받을 필드 이름
      fileBytes, // 선택한 파일의 바이트
      filename: upload.uploadFileNm, // 파일 이름
      contentType: MediaType('audio', 'mpeg'), // MIME 타입
    );
  }


  static Future<http.MultipartFile?> fnSetUploadImageFile(Upload upload, serverFileNm) async {

    File file = File(upload.uploadImage!.files.first.path.toString());
    List<int> fileBytes = await file.readAsBytes();

    return http.MultipartFile.fromBytes(
      serverFileNm, // 서버에서 받을 필드 이름
      fileBytes,
      filename: upload.uploadImageNm ?? "", // 파일 이름
      contentType: MediaType('image', 'jpeg'), // MIME 타입 (필요에 따라 수정)
    );

  }


  static Future<dynamic> apiCall(
      String url, {
        String method = 'GET',  // 기본값 'GET'
        Map<String, String>? headers,  // 요청 헤더 (optional)
        Map<String, dynamic>? body,    // 요청 바디 (optional)
        List<http.MultipartFile?>? fileList, // 파일 첨부 (optional)
        bool isGetRefreshToken = false,
      }) async {
    try {
      print('공통 API 호출 : ' + url);

      var uri = Uri.parse(dotenv.get('API_URL') + url);
      var request;

      final storage = FlutterSecureStorage();

      if(isGetRefreshToken){
        String? refreshToken = await storage.read(key: "refresh_token");
          if (refreshToken != null) {
            headers ??= {}; // headers가 null인 경우 빈 맵으로 초기화
            headers['Refresh-Token'] = refreshToken; // 액세스 토큰을 Authorization 헤더에 추가
          }
        } else {
          String? jwtToken = await storage.read(key: "jwt_token");
          if (jwtToken != null) {
            headers ??= {};  // headers가 null인 경우 빈 맵으로 초기화
            if(!url.startsWith("/auth/")){
              headers['Authorization'] = 'Bearer $jwtToken';  // 액세스 토큰을 Authorization 헤더에 추가
            }
          }
        }

      if (method == 'POST' || method == 'PUT') {
        // POST 요청 처리
        if (fileList != null && fileList.length != 0) {
          // 파일이 있는 경우 Multipart 요청 사용
          request = http.MultipartRequest(method, uri)
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
          request = http.Request(method, uri)
            ..headers.addAll(headers ?? {})
            ..body = json.encode(body);

        }
        // POST 요청 보내기
        var response = await request.send();
        var httpResponse = await http.Response.fromStream(response);

        if (httpResponse.body.isEmpty) {
          return null; // 빈 본문 처리
        }

        return await _processResponse(httpResponse, url, method, headers, body, fileList);

      } else if (method == 'GET') {
        // GET 요청 처리
        var response = await http.get(uri, headers: headers);
        return await _processResponse(response, url, method, headers, body, fileList);

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
  static Future<dynamic> _processResponse(
      http.Response response,
      String url,
      String method,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      List<http.MultipartFile?>? fileList,) async {

    if (response.statusCode == 200) {
      // 성공적인 응답 처리
      final decodedBody = utf8.decode(response.bodyBytes);
      return json.decode(decodedBody);

    } else if (response.statusCode == 401){
      // Refresh 토큰을 사용하여 새로운 JWT 토큰을 얻어오는 로직
      var refreshResponse = await _getRefreshToken();

      if (refreshResponse['status'] != "200") {
        AuthProv authProv = Provider.of<AuthProv>(navigatorKey.currentContext!, listen: false);
        await authProv.logout();
        GoRouter.of(navigatorKey.currentState!.context).push("/splash");
        return null;
      }

      const storage = FlutterSecureStorage();
      await storage.write(key: "jwt_token", value: refreshResponse['jwtToken']);  // JWT 토큰 저장
      // 새로운 토큰을 사용하여 원래의 API 호출을 재시도
      return await apiCall(url, method: method, headers: headers, body: body, fileList: fileList,isGetRefreshToken: false);

    } else {
      print('Failed request with status: ${response.statusCode}');
      return null;
    }
  }

  static Future<dynamic> _getRefreshToken() async {

    var response = await Helpers.apiCall(
        '/auth/refreshToken',
        method: "POST",
        headers: {
          'Content-Type': 'application/json', // JSON 형식
        },
        isGetRefreshToken: true
    );

    return response;
  }


}
