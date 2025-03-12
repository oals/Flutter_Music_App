import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/comn/upload.dart';

import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:skrrskrr/utils/helpers.dart';

class ImageProv extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }

  String imageLoader(imagePath) {
    if (imagePath == "" || imagePath == null) {
      imagePath = "C:/uploads/trackImage/defaultTrackImage";
    }

    final url = dotenv.get('API_URL') +
        '/viewer/imageLoader?trackImagePath=${imagePath}';
    return url;
  }

  Future<String> updateMemberImage(Upload? upload) async {
    List<http.MultipartFile?> fileList = [];
    final url = '/api/updateMemberImage';

    try {
      if (upload != null) {
        File file = File(upload.uploadImage!.files.first.path.toString());
        List<int> fileBytes = await file.readAsBytes();

        // 바이트 배열을 멀티파트 파일로 추가
        fileList.add(
          http.MultipartFile.fromBytes(
            'uploadImage', // 서버에서 받을 필드 이름
            fileBytes, // 선택한 파일의 바이트
            filename: upload.uploadImageNm ?? "", // 파일 이름
            contentType: MediaType('image', 'jpeg'), // MIME 타입 (필요에 따라 수정)
          ),
        );
      }

      // POST 요청
      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        fileList: fileList,
        body: {
          'memberId': upload?.memberId.toString(),
        },
      );



      if (response['status'] == "200") {
        return response['imagePath'];
      }


      throw Exception('Failed to load data');

    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return "";
    }
  }

  Future<String> updateTrackImage(Upload? upload) async {

    List<http.MultipartFile?> fileList = [];
    final url = '/api/updateTrackImage';

    try {

      // 이미지 파일 추가
      if (upload != null) {

        File file = File(upload.uploadImage!.files.first.path.toString());
        List<int> fileBytes = await file.readAsBytes();

        // 바이트 배열을 멀티파트 파일로 추가
        fileList.add(
          http.MultipartFile.fromBytes(
            'uploadImage', // 서버에서 받을 필드 이름
            fileBytes, // 선택한 파일의 바이트
            filename: upload.uploadImageNm ?? "", // 파일 이름
            contentType: MediaType('image', 'jpeg'), // MIME 타입 (필요에 따라 수정)
          ),
        );

      }


      // POST 요청
      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        fileList: fileList,
        body: {
          'trackId': upload?.trackId.toString(),
        },
      );


      if(response['status'] == "200"){
        return response['imagePath'];
      }

      throw Exception('Failed to load data');
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return "";
    }
  }
}
