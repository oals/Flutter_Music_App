import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/main.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/auth_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';

import 'package:skrrskrr/fcm/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    AppProv appProv = Provider.of<AppProv>(context,listen: false);
    AuthProv authProv = Provider.of<AuthProv>(context);


    return Scaffold(
      body: Container(
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
              bottom: 140,
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

                  Container(
                    width: 100.w,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.transparent), // 버튼 배경을 투명으로 설정
                        shadowColor: WidgetStateProperty.all(Colors.transparent), // 그림자 제거
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
                        )),
                      ),
                      onPressed: () async {
                        User? user = await _authService.signInWithGoogle();
                        if (user != null) {
                          bool isCreateJwt = await authProv.fnCreateJwtToken(user);
                          if(isCreateJwt) {
                            bool isGetMemberInfo = await appProv.firstLoad(user.email!);
                            if (isGetMemberInfo) {
                              GoRouter.of(context).push('/home/${false}');
                            } else {
                              Fluttertoast.showToast(msg: '잠시 후 다시 시도해주세요..');
                            }
                          } else {
                            Fluttertoast.showToast(msg: '잠시 후 다시 시도해주세요..');
                        }
                        } else {
                          Fluttertoast.showToast(msg: '로그인 실패');
                        }
                      },
                      child: Container(
                        width: 100.w,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3,color: Colors.black12),
                          gradient: LinearGradient(
                            colors: [Color(0xff200f2), Color(0xff8515e7)], // 그라데이션 색상
                            begin: Alignment.topLeft,  // 그라데이션 시작 방향
                            end: Alignment.bottomRight, // 그라데이션 끝 방향
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Start',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5),
                          ),
                        ),
                      )
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
