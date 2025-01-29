
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';

class AuthProv with ChangeNotifier{

  MemberModel model = MemberModel();


  void notify() {
    notifyListeners();
  }

  void clear() {
    model = MemberModel();
  }

  // jwt 토큰 생성
  Future<bool> fnGetJwtToken(User user) async {

    print('fnGetJwtToken');
    final url = 'getJwtToken';

    try {
      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'uid' : user.uid.toString(),
          'email' : user.email
        }
      );

      if (response != null) {
        if(response['status'] == '200'){

          final storage = FlutterSecureStorage();
          await storage.write(key: "jwt_token", value: response['jwtToken']);
          await storage.write(key: "refresh_token", value: response['refreshToken']);

          return true;
        } else {
          return false;
        }
      } else {
        // 오류 처리
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  // jwt token 검증
  Future<bool> fnJwtAuthing(String? jwtToken) async {

    print('fnJwtAuthing');
    final url = 'jwtAuthing';


    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
      );

      if (response != null) {
        if(response['status'] == '200'){
          return true;
        }
      } else {
        // 오류 처리
        return false;
      }
      return false;
    } catch (error) {
      return false;
    }
  }


  // jwt refresh token 검증
  Future<bool> fnRefreshJwtAuthing(String? refreshJwtToken) async {

    print('fnRefreshJwtAuthing');
    final url = 'jwtAuthing';
    final refresh_jwt_Token = refreshJwtToken;

    try {
      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refresh_jwt_Token',
        },

      );

      if (response != null) {
        print(response);

        if(response['status'] == '200'){
          String newJwtToken = response['new_jwt_token'];
          final storage = FlutterSecureStorage();
          await storage.write(key: "jwt_token", value: newJwtToken);
          return true;
        }
      } else {
        // 오류 처리
        return false;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }


  // 파이어베이스 id Token 인증을 위한
  Future<bool> fnFireBaseAuthing(User user) async {

    print('fnFireBaseAuthing');
    final url = 'fireBaseAuthing';


    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await user.getIdToken()}',
          },
      );

      if (response != null) {
        if(response['status'] == '200'){
          print(response);


          return true;
        } else {
          return false;
        }
      } else {
        // 오류 처리
        return false;
      }
    } catch (error) {
      return false;
    }
  }





  Future<void> logout() async {
    final storage = FlutterSecureStorage();
    SharedPreferences prefs =
    await SharedPreferences.getInstance();
    await prefs.clear();

    // 저장된 JWT 토큰 삭제
    await storage.delete(key: "jwt_token");
    await storage.delete(key: "refresh_token");

    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    // Firebase Authentication 로그아웃
    await FirebaseAuth.instance.signOut();
    model.memberEmail = null;
    notifyListeners(); // 상태 변경 알림
  }


}