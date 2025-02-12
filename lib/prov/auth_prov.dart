
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

    final url= '/auth/getJwtToken';

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

      if(response['status'] == '200'){

        final storage = FlutterSecureStorage();
        await storage.write(key: "jwt_token", value: response['jwtToken']);
        await storage.write(key: "refresh_token", value: response['refreshToken']);
        print('$url - Successful');
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }

  // jwt token 검증
  Future<bool> fnJwtAuthing(String? jwtToken) async {

    final url= '/auth/jwtAuthing';

    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
      );

      if(response['status'] == '200'){
        print('$url - Successful');
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }


  // jwt refresh token 검증 및 발행
  Future<bool> fnRefreshJwtAuthing(String? refreshJwtToken) async {

    final url= '/auth/jwtAuthing';
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

      if(response['status'] == '200'){
        String newJwtToken = response['new_jwt_token'];
        final storage = FlutterSecureStorage();
        await storage.write(key: "jwt_token", value: newJwtToken);
        print('$url - Successful');
        return true;

      } else {
        throw Exception('Failed to load data');
      }
      return false;
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }


  // 파이어베이스 id Token 인증을 위한
  Future<bool> fnFireBaseAuthing(User user) async {

    final url= '/auth/fireBaseAuthing';

    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await user.getIdToken()}',
          },
      );

      if(response['status'] == '200'){
        print('$url - Successful');
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
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