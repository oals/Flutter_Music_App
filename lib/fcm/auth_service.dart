import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skrrskrr/utils/helpers.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId : dotenv.get("WEB_OAUTH_2_CLIENT_ID")
  );

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
    try {
      final response = await Helpers.apiCall(
          'fireBaseAuthing',
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await userCredential.user?.getIdToken()}',
          },

      );

      if(response['status'] == '200'){

        return userCredential.user;

      } else {
        // 오류 처리
        return null;
      }
    } catch (error) {
      return null;
    }



  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
  }
}
