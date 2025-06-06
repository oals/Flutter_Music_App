import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/member/member_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/playlist_square_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/utils/share_utils.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    print('home init');
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShareUtils.deepLinkMove();
      FcmNotifications.fcmBackgroundDeepLink(context);
    });
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

                  Container(
                    width: 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),

                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommended Track',
                                style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Wrap(
                                  spacing: 5.0, // 아이템 간의 가로 간격
                                  runSpacing: 20.0, // 줄 간격
                                  alignment: WrapAlignment.spaceBetween,
                                  children: trackProv.recommendTrackList.asMap().entries.map((entry) {
                                    int i = entry.key;  // 인덱스
                                    Track trackItem = entry.value; // 리스트 요소

                                    return Row(
                                      children: [
                                        TrackSquareItem(
                                          trackItem: trackItem,
                                          trackItemIdx : i ,
                                          appScreenName: "PopularTrackList",
                                          initAudioPlayerTrackListCallBack: () {

                                            List<int> trackIdList = trackProv.recommendTrackList.map((item) => int.parse(item.trackId.toString())).toList();

                                            trackProv.audioPlayerTrackList = List.from(trackProv.recommendTrackList);
                                            trackProv.setAudioPlayerTrackIdList(trackIdList);
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
                          padding: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                PlaylistSquareItem(
                                  playList: playListProv.recommendAlbumList.playList,
                                  isHome: true,
                                  isAlbum : true,
                                ),
                              ],
                            ),
                          )
                        ),

                        /** 추천 플레이리스트 */
                        SizedBox(
                          height: 20,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
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
                          padding: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                PlaylistSquareItem(
                                  playList: playListProv.recommendPlayListsList.playList,
                                  isHome: true,
                                  isAlbum : false,
                                ),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        if (trackProv.lastListenTrackList.length != 0)...[
                          Padding(
                            padding: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
                            child: Container(
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
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 5.0,
                                runSpacing: 20.0,
                                alignment: WrapAlignment.spaceBetween,
                                children: trackProv.lastListenTrackList.asMap().entries.map((entry) {
                                  int i = entry.key;
                                  Track trackItem = entry.value;
                                  return Row(
                                    children: [
                                      TrackSquareItem(
                                        trackItem: trackItem,
                                        trackItemIdx: i,
                                        appScreenName: "LastListenTrackList",
                                        initAudioPlayerTrackListCallBack: () {

                                          List<int> trackIdList = trackProv.lastListenTrackList.map((item) => int.parse(item.trackId.toString())).toList();
                                          trackProv.audioPlayerTrackList = List.from(trackProv.lastListenTrackList);
                                          trackProv.setAudioPlayerTrackIdList(trackIdList);
                                          trackProv.notify();
                                        },
                                      ),

                                      SizedBox(width: 3,),
                                    ],
                                  );
                                },
                                ).toList(),
                              ),
                            ),
                          ),
                        ],

                        SizedBox(height: 20,),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0, left: 10, bottom: 10),
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
                                memberList: memberProv.recommendMemberList,
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
