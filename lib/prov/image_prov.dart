
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


class ImageProv extends ChangeNotifier{

  void notify() {
    notifyListeners();
  }


  String imageLoader(imagePath) {
    if (imagePath == "" || imagePath == null) {
      // print('이미지없음');
      imagePath = "C:/uploads/trackImage/defaultTrackImage";
    }

    final url = dotenv.get('API_URL') + 'imageLoader?trackImagePath=${imagePath}';

    // print(url);
    return url;
  }





  Future<String> setMemberImage(Upload? upload) async {


    var request = http.MultipartRequest(
      'POST',
      Uri.parse( dotenv.get('API_URL') + 'setMemberImage'),
    );

    try {


      // 이미지 파일 추가
      if(upload != null){

        request.fields['memberId'] = upload.memberId.toString();


        File file = File(upload.uploadImage!.files.first.path.toString());
        List<int> fileBytes = await file.readAsBytes();

        // 바이트 배열을 멀티파트 파일로 추가
        request.files.add(
          http.MultipartFile.fromBytes(
            'uploadImage', // 서버에서 받을 필드 이름
            fileBytes, // 선택한 파일의 바이트
            filename: upload.uploadImageNm ?? "", // 파일 이름
            contentType: MediaType('image', 'jpeg'), // MIME 타입 (필요에 따라 수정)
          ),
        );

        // 요청 보내기
        var response = await request.send();
        if (response.statusCode == 200) {

          var responseBody = await http.Response.fromStream(response);

          return responseBody.body;




        } else {
          print('Upload failed: ${response.statusCode}');
        }

      }



      return "";

    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return "";

    }
  }

  Future<String> setTrackImage(Upload? upload) async {


    var request = http.MultipartRequest(
      'POST',
      Uri.parse( dotenv.get('API_URL') + 'setTrackImage'),
    );

    try {

      // 이미지 파일 추가
      if(upload != null){

        request.fields['trackId'] = upload.trackId.toString();

        File file = File(upload.uploadImage!.files.first.path.toString());
        List<int> fileBytes = await file.readAsBytes();

        // 바이트 배열을 멀티파트 파일로 추가
        request.files.add(
          http.MultipartFile.fromBytes(
            'uploadImage', // 서버에서 받을 필드 이름
            fileBytes, // 선택한 파일의 바이트
            filename: upload.uploadImageNm ?? "", // 파일 이름
            contentType: MediaType('image', 'jpeg'), // MIME 타입 (필요에 따라 수정)
          ),
        );

        // 요청 보내기
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await http.Response.fromStream(response);
          return responseBody.body;
        }
      }

      return "";

    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return "";

    }
  }

  }

