import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/upload/upload.dart';

import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class ImageProv extends ChangeNotifier {

  void notify() {
    notifyListeners();
  }

  String imageLoader(imagePath) {

    if (imagePath == "" || imagePath == null) {
      imagePath = "C:/uploads/trackImage/defaultTrackImage";
    }

    final url = dotenv.get('API_URL') + '/viewer/imageLoader?trackImagePath=${imagePath}';

    return url;
  }

  Future<String> updateMemberImage(Upload? upload) async {

    List<http.MultipartFile?> fileList = [];
    final url = '/api/updateMemberImage';

    try {
      if (upload != null) {
        fileList.add(await ComnUtils.fnSetUploadImageFile(upload, "uploadImage"));
      }

      http.Response response = await ComnUtils.apiCall(
        url,
        method: "POST",
        headers: {
          'Content-Type': 'application/json'
        },
        fileList: fileList,
        body: {
          'loginMemberId': upload?.memberId.toString(),
        },
      );

      if (response.statusCode == 200) {
        return ComnUtils.extractValue(response.body, 'memberImagePath').toString();
      }
      throw Exception(ComnUtils.extractValue(response.body, 'message'));
    } catch (error) {
      print(error);
      print('$url - Fail');
      return "";
    }
  }

  Future<String> updateTrackImage(Upload? upload) async {

    List<http.MultipartFile?> fileList = [];
    final url = '/api/updateTrackImage';

    try {
      if (upload != null) {
        fileList.add(await ComnUtils.fnSetUploadImageFile(upload, "uploadImage"));
      }

      http.Response response = await ComnUtils.apiCall(
        url,
        method: "POST",
        headers: {
          'Content-Type': 'application/json'
        },
        fileList: fileList,
        body: {
          'trackId': upload?.trackId.toString(),
        },
      );

      if (response.statusCode == 200) {
        return ComnUtils.extractValue(response.body, "trackImagePath").toString();
      }
      throw Exception(ComnUtils.extractValue(response.body, 'message'));
    } catch (error) {
      print(error);
      print('$url - Fail');
      return "";
    }
  }
}
