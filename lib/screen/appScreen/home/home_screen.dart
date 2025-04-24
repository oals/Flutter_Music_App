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
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/category/category_square_item.dart';
import 'package:skrrskrr/screen/subScreen/member/member_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';

import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenStateState createState() => _HomeScreenStateState();
}


class _HomeScreenStateState extends State<HomeScreen> {
  late PlayListProv playListProv;
  late MemberProv memberProv;
  late PlayerProv playerProv;
  late TrackProv trackProv;
  List<Track> recommendTrackList = [];
  late Future<bool>? _getRecommendPlayListFuture;
  late Future<bool>? _getRecommendAlbumFuture;
  late Future<bool>? _getRecommendTrackFuture;
  late Future<bool>? _getRecommendMember;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRecommendTrackFuture = Provider.of<TrackProv>(context, listen: false).getRecommendTrackList();
    _getRecommendPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getRecommendPlayList();
    _getRecommendAlbumFuture = Provider.of<PlayListProv>(context, listen: false).getRecommendAlbum();
    _getRecommendMember = Provider.of<MemberProv>(context, listen: false).getRecommendMember();
  }


  @override
  Widget build(BuildContext context) {

    trackProv = Provider.of<TrackProv>(context, listen: false);
    memberProv = Provider.of<MemberProv>(context,listen: false);
    playListProv = Provider.of<PlayListProv>(context,listen: false);
    playerProv = Provider.of<PlayerProv>(context,listen: false);


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
                    width: 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

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

                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommend Track',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              FutureBuilder<bool>(
                                  future: _getRecommendTrackFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    }

                                    if (recommendTrackList.isEmpty) {
                                      recommendTrackList = trackProv.trackListFilter("RecommendTrackList");
                                    }

                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Wrap(
                                            spacing: 5.0, // 아이템 간의 가로 간격
                                            runSpacing: 20.0, // 줄 간격
                                            alignment: WrapAlignment.spaceBetween,
                                            children: recommendTrackList.map((item) {
                                              return Row(
                                                children: [
                                                  TrackSquareItem(
                                                    trackItem: item,
                                                    appScreenName: "PopularTrackList",
                                                    initAudioPlayerTrackListCallBack: () async {

                                                      List<int> trackIdList = recommendTrackList.map((item) => int.parse(item.trackId.toString())).toList();

                                                      trackProv.audioPlayerTrackList = recommendTrackList;
                                                      await trackProv.setAudioPlayerTrackIdList(trackIdList);
                                                      trackProv.notify();

                                                    },
                                                  ),

                                                  SizedBox(width: 3,),
                                                ],
                                              );
                                            },
                                            ).toList(),
                                          ),

                                        ],
                                      ),
                                    );
                                  }
                              ),


                            ],
                          ),
                        ),
                        SizedBox(height: 20,),

                        /** 추천 앨범 */
                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
                          child: Text(
                            'Recommended Album',
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                        ),

                        SizedBox(
                          height: 3,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 10,),
                          child: FutureBuilder<bool>(
                              future: _getRecommendAlbumFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {

                                  List<PlayListInfoModel> playList = playListProv.albums.playList;

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        PlayListSquareItem(
                                          playList: playList,
                                          isHome: true,
                                          isAlbum : true,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                          ),
                        ),

                        /** 추천 플레이리스트 */
                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          child: Text(
                            'Recommended Playlist',
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20),
                          ),
                        ),

                        SizedBox(
                          height: 3,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 10,),
                          child: FutureBuilder<bool>(
                              future: _getRecommendPlayListFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {

                                  List<PlayListInfoModel> playList = playListProv.playlists.playList;

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        PlayListSquareItem(
                                          playList: playList,
                                          isHome: true,
                                          isAlbum : false,
                                        ),

                                      ],
                                    ),
                                  );
                                }
                              }
                          ),
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
                                  future: _getRecommendMember,
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
