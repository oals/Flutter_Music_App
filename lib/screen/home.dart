import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/home/home_model.dart';
import 'package:skrrskrr/prov/home_prov.dart';

import 'package:skrrskrr/screen/appScreen/playlist/play_list.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar_v2.dart';
import 'package:skrrskrr/screen/subScreen/category/category_square_item.dart';
import 'package:skrrskrr/screen/subScreen/member/member_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/screen/appScreen/upload/upload.dart';
import 'package:skrrskrr/screen/appScreen/member/user_page.dart';
import 'package:skrrskrr/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) =>
              HomeScreenState(),
        );
      },
    );
  }
}

class HomeScreenState extends StatefulWidget {

  HomeScreenState();

  @override
  State<HomeScreenState> createState() => _HomeScreenStateState();
}

class _HomeScreenStateState extends State<HomeScreenState> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    HomeProv homeProv = Provider.of<HomeProv>(context);

    print('홈 빌드');

    // 0xff200f2e

    return Scaffold(

      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          child: FutureBuilder<bool>(
              future: !isLoading ? homeProv.firstLoad() : null, // 비동기 함수 호출
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SizedBox()
                  );
                } else {
                  isLoading = true;
                  HomeModel homeModel = homeProv.model;

                  // 데이터가 성공적으로 로드되었을 때
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CustomAppbarV2(
                      //   isNotification: true,
                      // ),
                      SizedBox(height: 10,),

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('카테고리',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                            ),
                            SizedBox(height: 13,),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    GoRouter.of(context).push('/category/${1}');
                                  },
                                    child: CategorySquareItem(imageWidth: 30, imagePath:   'assets/images/testImage3.png', imageText: "Month", imageSubText: "Beat")),
                                SizedBox(width: 10,),
                                CategorySquareItem(imageWidth: 30, imagePath:   'assets/images/testImage4.png', imageText: "Month", imageSubText: "Ballad"),
                                SizedBox(width: 10,),
                                CategorySquareItem(imageWidth: 30, imagePath:   'assets/images/testImage5.png', imageText: "Month", imageSubText: "Rock"),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategorySquareItem(imageWidth: 46, imagePath:   'assets/images/testImage5.png', imageText: "Month", imageSubText: "Hip-Hop"),
                                SizedBox(width: 10,),
                                CategorySquareItem(imageWidth: 46, imagePath:   'assets/images/testImage6.png', imageText: "Month", imageSubText: "K-Pop"),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage7.png', imageText: "Month", imageSubText: "Beat"),
                                SizedBox(width: 4,),
                                CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage8.png', imageText: "Month", imageSubText: "Rock"),
                                SizedBox(width: 4,),
                                CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage9.png', imageText: "Month", imageSubText: "Rock"),
                                SizedBox(width: 4,),
                                CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage10.png', imageText: "Month", imageSubText: "Rock"),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 100.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 플레이 리스트 영역
                            SizedBox(
                              height: 30,
                            ),

                            Text(
                              '앨범',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                            ),

                            SizedBox(
                              height: 13,
                            ),


                            Text(
                              '내가 감상한 음악',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                            ),

                            SizedBox(
                              height: 13,
                            ),

                            Text(
                              '플레이 리스트',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                            ),

                            SizedBox(
                              height: 13,
                            ),

                            PlayListSquareItem(
                              playList: homeModel.popularPlayList,
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              child: Text(
                                '팔로우한 유저의 새로운 곡',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            for(int i = 0; i <homeModel.followMemberTrackList.length; i++)...[
                              Column(
                                children: [
                                  TrackListItem(
                                    trackItem: homeModel.followMemberTrackList[i],

                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),

                            ],

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              child: Text(
                                '추천',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),


                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for(int i = 0; i< homeModel.trendingTrackList.length; i++)...[
                                      TrackSquareItem(
                                        track: homeModel.trendingTrackList[i],

                                        bgColor: Colors.lightBlueAccent,
                                      ),
                                      SizedBox(width: 15,),
                                    ]

                                  ],
                                )
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            Container(
                              child: Text(
                                '내가 좋아요 한 트랙',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for(int i = 0; i< homeModel.likedTrackList.length; i++)...[
                                      TrackSquareItem(
                                      track: homeModel.likedTrackList[i],

                                      bgColor: Colors.redAccent,
                                      ),
                                      SizedBox(width: 15,),
                                    ]

                                  ],
                                )
                            ),
                            SizedBox(
                              height: 20,
                            ),


                            Container(
                              child: Text(
                                'Artists you should follow',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MemberScrollHorizontalItem(
                                memberList: homeModel.randomMemberList,

                            ),

                            SizedBox(height: 120,),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
