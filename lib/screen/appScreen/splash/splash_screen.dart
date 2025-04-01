import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/main.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/prov/auth_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';

import 'package:skrrskrr/screen/appScreen/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    print("SplashScreen initState");
    super.initState();
    _checkUser();
  }

  void _checkUser() {
    User? user = FirebaseAuth.instance.currentUser; // 현재 사용자 정보 가져오기

    Timer(Duration(seconds: 1), () async {
      if (user == null) {
        // 유저가 로그인 안 되어 있으면 Login 화면으로 이동
        GoRouter.of(context).push('/login');
        return;
      }

      AuthProv authProv = Provider.of<AuthProv>(context, listen: false);
      MemberProv memberProv = Provider.of<MemberProv>(context, listen: false);
      final storage = FlutterSecureStorage();


      Future<void> _jwtAuthing() async {
        final jwt_Token = await storage.read(key: "jwt_token");
        print("파이어베이스 검증 후 jwt 토큰 검증 진행 api 호출 ");

        bool isJwtAuth = await authProv.fnJwtAuthing(jwt_Token);
        if (isJwtAuth) {
          // 인증 성공
          await memberProv.getMemberInfo(user.email!);
          GoRouter.of(context).pushReplacement('/home/${false}');
        } else {
          GoRouter.of(context).pushReplacement('/login');

        }
      }

      Future<void> _handleAuth(User user) async {
        bool isFireBaseAuth = await authProv.fnFireBaseAuthing(user);
        if (isFireBaseAuth) {
          _jwtAuthing();
        }
      }

      // 첫 번째 인증 시도
      await _handleAuth(user);
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          width: 100.w,
          height: 100.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff000000), // 상단의 연한 색
                Color(0xff000000),    // 하단의 어두운 색
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/intro.png',
                width: 100.w,
                height: 70.h,
                fit: BoxFit.cover,
              ),

              Positioned(
                bottom: 190,
                left: 10,
                right: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('AudioX',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w900),),
                    SizedBox(height: 10,),
                    Text('listen to your favorite music for',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700),),
                    Text('free, anywhere',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700),),
                    SizedBox(height: 30,),

                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}

