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
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/auth_prov.dart';

import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';
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
  late AuthProv authProv;
  late TrackProv trackProv;
  List<Track> lastListenTrackList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    authProv = Provider.of<AuthProv>(context);
    trackProv = Provider.of<TrackProv>(context);

    TrackList trackModel = trackProv.trackModel;

    trackModel.trackList.forEach((item){
      if(item.trackListCd.contains(1)){
        lastListenTrackList.add(item);
      }
    });


    List<String> cateogryList = [
      'My page',
      'Liked Tracks',
      'Albums',
      'Playlists',
      'Uploaded',
      'Following',
      'Logout'
    ];

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        color: Color(0xff000000),
        width: 100.w,
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < 7; i++) ...[
              Container(
                padding: EdgeInsets.only(bottom: 8, top: 8),
                child: GestureDetector(
                    onTap: () async {
                      PlayerProv playerProv =
                          Provider.of<PlayerProv>(context, listen: false);
                      ;
                      String loginMemberId = await Helpers.getMemberId();
                      if (i == 0) {
                        GoRouter.of(context).push('/userPage/${loginMemberId}');
                      } else if (i == 1) {
                        GoRouter.of(context)
                            .push('/adminLikeTrack/${loginMemberId}');
                      } else if (i == 2) {
                        GoRouter.of(context)
                            .push('/adminAlbum/${loginMemberId}');
                      } else if (i == 3) {
                        GoRouter.of(context)
                            .push('/adminPlayList/${loginMemberId}');
                      } else if (i == 4) {
                        GoRouter.of(context)
                            .push('/adminUploadTrack/${loginMemberId}');
                      } else if (i == 5) {
                        GoRouter.of(context)
                            .push('/adminFollow/${loginMemberId}');
                      } else if (i == 6) {
                        print('로그아웃 클릭');
                        await playerProv.audioPause();
                        await authProv.logout();
                        context.go('/splash');
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
              if (i != 6)
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
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recently Listened Track',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  // Text(
                  //   'more',
                  //   style: TextStyle(
                  //       fontSize: 14,
                  //       color: Colors.grey,
                  //       fontWeight: FontWeight.w700),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TrackScrollHorizontalItem(
              trackList: lastListenTrackList,
                bgColor: Colors.greenAccent,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
