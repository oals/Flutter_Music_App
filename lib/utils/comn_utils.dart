
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skrrskrr/model/upload/upload.dart';
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

class ComnUtils {

  static List<String>? categoryList;

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
      return null;
    }
  }

  static bool getIsAuth(String checkMemberId, String loginMemberId)  {
    return checkMemberId == loginMemberId;
  }

  static Future<String> getMemberId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("memberId") ?? '';
  }


  static Future<String?> pickImage(int? id, bool isMemberImage, BuildContext context) async {
    try {

      final ImageProv imageProv = Provider.of<ImageProv>(context,listen: false);
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      Upload upload = Upload();

      if (isMemberImage) {
        upload.memberId = id;
      } else {
        upload.trackId = id;
      }

      if (image != null) {
        Uint8List? _imageBytes = await ComnUtils.cropImage(image.path);

        if (_imageBytes != null) {
          FilePickerResult filePickerResult = await ComnUtils.convertUint8ListToFilePickerResult(
            _imageBytes,
            _imageBytes.lengthInBytes,
          );

          upload.uploadImage = filePickerResult;
          upload.uploadImageNm = image.path.split('/').last;

          String? newImagePath = null;
          if (isMemberImage) {
            newImagePath = await imageProv.updateMemberImage(upload);
          } else {
            newImagePath = await imageProv.updateTrackImage(upload);
          }

          return newImagePath;

        } else {
          print("이미지를 자르는 중 문제가 발생했습니다.");
        }
      } else {
        print("이미지가 선택되지 않았습니다.");
      }
    } catch (e) {
      print("이미지 선택 또는 처리 중 오류 발생: $e");
    }

    return null;
  }

  static String getCategory(int trackCategoryId) {
    return categoryList![trackCategoryId - 1];
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

    String fileType = upload.uploadImageNm?.endsWith('.png') ?? false ? 'png' : 'jpeg';


    return http.MultipartFile.fromBytes(
      serverFileNm, // 서버에서 받을 필드 이름
      fileBytes,
      filename: upload.uploadImageNm ?? "",
      contentType: MediaType('image', fileType),

    );

  }

  static dynamic extractValue(String responseBody, String key) {
    try {
      final String decodedBody = utf8.decode(responseBody.codeUnits);

      final Map<String, dynamic> jsonData = jsonDecode(decodedBody);

      return jsonData.containsKey(key) ? jsonData[key] : null;
    } catch (e) {
      print('Error decoding JSON or extracting key: $e');
      return null;
    }
  }

  static Future<http.Response> apiCall(
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

      if (isGetRefreshToken){
        String? refreshToken = await storage.read(key: "refresh_token");
        if (refreshToken != null) {
          headers ??= {}; // headers가 null인 경우 빈 맵으로 초기화
          headers['Refresh-Token'] = refreshToken; // 액세스 토큰을 Authorization 헤더에 추가
        }
      } else {
        String? jwtToken = await storage.read(key: "jwt_token");
        if (jwtToken != null) {
          headers ??= {};  // headers가 null인 경우 빈 맵으로 초기화
          if (!url.startsWith("/auth/")) {
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
          return httpResponse; // 빈 본문 처리
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
        return http.Response(json.encode({'message': '$error'}), 500,);
      }
    }

  // 응답 처리 (공통 처리)
  static Future<http.Response> _processResponse(
      http.Response response,
      String url,
      String method,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      List<http.MultipartFile?>? fileList,) async {

    if (response.statusCode == 200) {
      // 성공적인 응답 처리
      final decodedBody = utf8.decode(response.bodyBytes);
      return response;

    } else if (response.statusCode == 401){
      // Refresh 토큰을 사용하여 새로운 JWT 토큰을 얻어오는 로직
      http.Response refreshResponse = await _getRefreshToken();

      if (refreshResponse.statusCode != 200) {
        AuthProv authProv = Provider.of<AuthProv>(navigatorKey.currentContext!, listen: false);
        await authProv.logout();
        GoRouter.of(navigatorKey.currentState!.context).push("/splash");
        return http.Response(json.encode({'message': '리프레쉬 토큰 만료'}), refreshResponse.statusCode,);
      }

      const storage = FlutterSecureStorage();
      await storage.write(key: "jwt_token", value: ComnUtils.extractValue(refreshResponse.body, 'jwtToken'));  // JWT 토큰 저장
      // 새로운 토큰을 사용하여 원래의 API 호출을 재시도
      return await apiCall(url, method: method, headers: headers, body: body, fileList: fileList,isGetRefreshToken: false);

    } else {
      return http.Response(json.encode({'message': 'Failed request with status: ${response.statusCode}'}), response.statusCode,);
    }
  }

  static Future<http.Response> _getRefreshToken() async {

    http.Response response = await ComnUtils.apiCall(
        '/auth/refreshToken',
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
        },
        isGetRefreshToken: true
    );

    return response;
  }

}
