import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/prov/auth_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';

import 'package:skrrskrr/screen/appScreen/comn/login.dart';
import 'package:skrrskrr/screen/appScreen/comn/splash.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar_v2.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_horizontal_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
    
    
  });


  

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    bool _isOn = false; // 스위치 상태 변수

    MemberProv memberProv = Provider.of<MemberProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);
    AuthProv authProv = Provider.of<AuthProv>(context);

    List<String> cateogryList = [
      '내 정보',
      '관심 트랙',
      '플레이리스트',
      '업로드한 트랙',
      '팔로잉',
      '로그아웃'
    ];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        color: Color(0xff000000),
        width: 100.w,
        height: 130.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            for (int i = 0; i < 6; i++) ...[
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: GestureDetector(
                    onTap: () async {
                      String adminId = await Helpers.getMemberId();
                      if (i == 0) {
                        GoRouter.of(context).push('/userPage/${adminId}');
                      } else if (i == 1) {
                        GoRouter.of(context).push('/adminLikeTrack/${adminId}');
                      } else if (i == 2) {
                        GoRouter.of(context).push('/adminPlayList/${adminId}');
                      } else if (i == 3) {
                        GoRouter.of(context).push('/adminUploadTrack/${adminId}');
                      } else if (i == 4) {
                        GoRouter.of(context).push('/adminFollow/${adminId}');
                      } else if (i == 5) {
                        print('로그아웃 클릭');

                        await authProv.logout();
                        GoRouter.of(context).push('/splash');

                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              cateogryList[i],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    )),
              ),
              if (i != 5)
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.2,
                      ),
                    ),
                  ),
                ),
            ],
            SizedBox(
              height: 25,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '최근 들은 곡',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'more',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // TrackScrollHorizontalItem(),
          ],
        ),
      ),
    );
  }
}
