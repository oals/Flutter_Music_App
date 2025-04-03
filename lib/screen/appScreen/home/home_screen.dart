import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/home/home_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/home_prov.dart';

import 'package:skrrskrr/screen/appScreen/playlist/play_list_screen.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/category/category_square_item.dart';
import 'package:skrrskrr/screen/subScreen/member/member_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_paging_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/screen/modal/upload/upload.dart';
import 'package:skrrskrr/screen/appScreen/member/user_page_screen.dart';
import 'package:skrrskrr/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenStateState createState() => _HomeScreenStateState();
}


class _HomeScreenStateState extends State<HomeScreen> {

  late Future<bool>? _getHomeInitFuture;
  List<List> lastListenTrackChunkedData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHomeInitFuture = Provider.of<HomeProv>(context, listen: false).firstLoad();
  }


  void test (List<Track> lastListenTrackList) {

    for (int i = 0; i < lastListenTrackList.length; i += 3) {
      lastListenTrackChunkedData.add(lastListenTrackList.sublist(i,
          (i + 3) > lastListenTrackList.length
              ? lastListenTrackList.length
              : (i + 3)));
    }

  }


  @override
  Widget build(BuildContext context) {

    HomeProv homeProv = Provider.of<HomeProv>(context);
    print('홈 빌드2');


    return Scaffold(

      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          child: FutureBuilder<bool>(
              future: _getHomeInitFuture, // 비동기 함수 호출
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SizedBox()
                  );
                } else {
                  HomeModel homeModel = homeProv.model;

                  test(homeModel.lastListenTrackList);

                  // 데이터가 성공적으로 로드되었을 때
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                            ),
                            SizedBox(height: 13,),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    GoRouter.of(context).push('/category/${1}');
                                  },
                                    child: CategorySquareItem(imageWidth: 30, imagePath: 'assets/images/testImage3.png', imageText: "Month", imageSubText: "Beat")),
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

                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recently Listened Track',
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),

                                  Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          for (var lastListenTrackList in lastListenTrackChunkedData)
                                            Column(
                                              children: [
                                                for (var track in lastListenTrackList)
                                                  TrackScrollPagingItem(track: track)
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Recommended Playlist',
                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                              ),
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
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New song from users I follow',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  for(int i = 0; i < homeModel.followMemberTrackList.length; i++)...[
                                    Column(
                                      children: [
                                        TrackListItem(
                                          trackItem: homeModel.followMemberTrackList[i],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],


                                ],
                              ),
                            ),



                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recommended Track',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  Container(
                                    child: TrackScrollHorizontalItem(
                                      trackList: homeModel.trendingTrackList,
                                      bgColor: Colors.blueAccent,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Check out the track I liked.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  Container(
                                    child: TrackScrollHorizontalItem(
                                      trackList: homeModel.likedTrackList,
                                      bgColor: Colors.redAccent,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),



                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Artists you should follow',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MemberScrollHorizontalItem(
                                    memberList: homeModel.randomMemberList,

                                  ),

                                ],
                              ),
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
