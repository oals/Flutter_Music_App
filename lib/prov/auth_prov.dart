
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
import 'package:skrrskrr/prov/user_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';

class AuthProv with ChangeNotifier{

  MemberModel model = MemberModel();


  void notify() {
    notifyListeners();
  }

  void clear() {
    model = MemberModel();
  }

  //인증을 위한
  Future<bool> fnAuthing(User user) async {

    print('fnAuthing');
    final url = 'authing';

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

          // String jwtToken = response['jwt_token'];
          // final storage = FlutterSecureStorage();
          // await storage.write(key: "Auth_token", value: jwtToken);

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
    SharedPreferences prefs =
    await SharedPreferences.getInstance();
    await prefs.clear();

    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    // Firebase Authentication 로그아웃
    await FirebaseAuth.instance.signOut();
    model.memberEmail = null;
    notifyListeners(); // 상태 변경 알림
  }


}