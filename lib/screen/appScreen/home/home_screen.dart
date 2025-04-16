import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/category/category_square_item.dart';
import 'package:skrrskrr/screen/subScreen/member/member_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenStateState createState() => _HomeScreenStateState();
}


class _HomeScreenStateState extends State<HomeScreen> {

  late Future<bool>? _getHomeInitPlayListFuture;
  late Future<bool>? _getHomeInitMemberFuture;
  List<Track> lastListenTrackList = [];
  List<Track> recommendedTrackList = [];
  List<Track> followTrackList = [];
  List<Track> likeTrackList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getHomeInitPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getHomeInitPlayList();
    _getHomeInitMemberFuture = Provider.of<MemberProv>(context, listen: false).getHomeInitMember();
    _initializeApiCalls(context);
  }


  Future<void> _initializeApiCalls(BuildContext context) async {
    final trackProv = Provider.of<TrackProv>(context, listen: false);

    try {
      await trackProv.getLastListenTrack();
      lastListenTrackList = trackProv.trackListFilter("LastListenTrackList");
      trackProv.updateTrackState(() => trackProv.isLastListenTrackLoaded = true);

      await trackProv.getRecommendTrackList(0,1);
      recommendedTrackList = trackProv.trackListFilter("RecommendTrackList");
      trackProv.updateTrackState(() => trackProv.isRecommendTrackLoaded = true);

      await trackProv.getFollowMemberTrack();
      followTrackList = trackProv.trackListFilter("FollowMemberTrackList");
      trackProv.updateTrackState(() => trackProv.isFollowMemberTrackLoaded = true);

      await trackProv.getLikeTrack(0);
      likeTrackList = trackProv.trackListFilter("MyLikeTrackList");
      trackProv.updateTrackState(() => trackProv.isLikeTrackLoaded = true);



      print("모든 API 작업 완료!");
    } catch (error) {
      print("오류 발생: $error");
    }
  }



  @override
  Widget build(BuildContext context) {


    MemberProv memberProv = Provider.of<MemberProv>(context,listen: false);
    PlayListProv playListProv = Provider.of<PlayListProv>(context,listen: false);

    print('홈 빌드2');


    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Consumer<TrackProv>(
              builder: (context, trackProv, _) {

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
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
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
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20),
                              ),

                              SizedBox(
                                height: 15,
                              ),
                              if (trackProv.isLastListenTrackLoaded)
                                Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for (var listItem in trackProv.chunkLastListenTrackList(lastListenTrackList))
                                        Column(
                                          children: [
                                            for (Track track in listItem)...[
                                              TrackListItem(trackItem: track, callBack: () async {

                                                  List<int> trackIdList = lastListenTrackList.map((item) => int.parse(item.trackId.toString())).toList();
                                                  await trackProv.setAudioPlayerTrackIdList(trackIdList);

                                              },),
                                              SizedBox(height: 10,),
                                            ],
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
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, bottom: 10),
                          child: Text(
                            'Recommended Playlist',
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                        ),

                        SizedBox(
                          height: 13,
                        ),

                        FutureBuilder<bool>(
                            future: _getHomeInitPlayListFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {

                                List<PlayListInfoModel> playList = playListProv.playListFilter("HomeInitPlayList");

                                return PlayListSquareItem(
                                  playList: playList,
                                );
                              }
                            }
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'New song from users I follow',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if ((trackProv.isFollowMemberTrackLoaded))
                          Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              for(int i = 0; i < followTrackList.length; i++)...[
                                Column(
                                  children: [
                                    TrackListItem(
                                      trackItem: followTrackList[i],
                                      callBack: () async {

                                        List<int> trackIdList = followTrackList.map((item) => int.parse(item.trackId.toString())).toList();
                                        await trackProv.setAudioPlayerTrackIdList(trackIdList);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
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
                              if((trackProv.isRecommendTrackLoaded))
                                Container(
                                child: TrackScrollHorizontalItem(
                                  trackList: recommendedTrackList,
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
                              if((trackProv.isLikeTrackLoaded))
                                TrackScrollHorizontalItem(
                                trackList: likeTrackList,
                                bgColor: Colors.redAccent,
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
                              FutureBuilder<bool>(
                                  future: _getHomeInitMemberFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return MemberScrollHorizontalItem(
                                        memberList: memberProv
                                            .memberModelList,
                                      );
                                    }
                                  }
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
          ),
        ),
      ),
    );
  }
}
