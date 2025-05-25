
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/handler/audio_back_state_handler.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/comment_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_router_config.dart';
import 'package:skrrskrr/utils/comn_utils.dart';
import 'package:http/http.dart' as http;

class AuthProv with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId : dotenv.get("WEB_OAUTH_2_CLIENT_ID")
  );

  void notify() {
    notifyListeners();
  }

  Future<bool> fnCreateJwtToken(User user) async {

    final url = '/auth/createJwtToken';

    try {
      http.Response response = await ComnUtils.apiCall(
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

      if (response.statusCode == 200) {

        final storage = FlutterSecureStorage();

        await storage.write(key: "jwt_token", value: ComnUtils.extractValue(response.body, 'jwtToken'));

        await storage.write(key: "refresh_token", value: ComnUtils.extractValue(response.body, 'refreshToken'));

        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> fnJwtAuthing(String? jwtToken) async {

    final url = '/auth/jwtAuthing';

    try {
      http.Response response = await ComnUtils.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
      );

      if (response.statusCode == 200) {
        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> fnFireBaseAuthing(User user) async {

    final url = '/auth/fireBaseAuthing';

    try {
      http.Response response = await ComnUtils.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await user.getIdToken()}',
          },
      );

      if (response.statusCode == 200) {
        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<User?> signInWithGoogle() async {
    /// 로그인 팝업 생성
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    ///로그인 된 계정에 대한 인증 토큰 가져오기
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    ///Firebase Authentication에 로그인할 수 있는  자격증명 생성
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    ///위 자격 증명을 받아 사용자가 올바른 구글 계정으로
    ///로그인한 것을 확인 및 로그인 정보를 담은 UserCredential 객체를 반환
    /// 구글 id token을 통해 파이어베이스 id token 얻음
    UserCredential userCredential = await _auth.signInWithCredential(credential);

    //idToken 검증 과정 위해 서버로 전송
    final url = '/auth/fireBaseAuthing';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await userCredential.user?.getIdToken()}',
        },
      );

      if (response.statusCode == 200) {
        return userCredential.user;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<void> logout() async {

    final storage = FlutterSecureStorage();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Provider.of<MemberProv>(navigatorKey.currentContext!,listen: false).clear();
    Provider.of<PlayerProv>(navigatorKey.currentContext!,listen: false).clear();
    Provider.of<TrackProv>(navigatorKey.currentContext!,listen: false).clear();
    Provider.of<PlayListProv>(navigatorKey.currentContext!,listen: false).clear();
    Provider.of<CommentProv>(navigatorKey.currentContext!,listen: false).clear();

    // 저장된 JWT 토큰 삭제
    await storage.delete(key: "jwt_token");
    await storage.delete(key: "refresh_token");

    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();

    await FirebaseAuth.instance.signOut();

    await AudioBackStateHandler.instance?.deleteMediaItem();

    notifyListeners(); // 상태 변경 알림
  }
}