import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/member/member_model_list.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';

import 'package:skrrskrr/screen/subScreen/follow/follow_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

import '../../../prov/player_prov.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({
    super.key,
    required this.searchText,
  });

  final String searchText;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late FollowProv followProv;
  late TrackProv trackProv;
  late PlayListProv playListProv;
  late MemberProv memberProv;
  late SearchProv searchProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool>? _getSearchTrackFuture;
  late Future<bool>? _getSearchPlayListFuture;
  late Future<bool>? _getSearchMemberFuture;

  List<Track> searchTrackList = [];
  List<PlayListInfoModel> searchPlayList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getSearchTrackFuture = Provider.of<TrackProv>(context, listen: false).getSearchTrack(widget.searchText,0,20);
    _getSearchPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getSearchPlayList(widget.searchText,0, 8);
    _getSearchMemberFuture = Provider.of<MemberProv>(context, listen: false).getSearchMember(widget.searchText,0, 6);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    comnLoadProv.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    followProv = Provider.of<FollowProv>(context);
    trackProv = Provider.of<TrackProv>(context);
    playListProv = Provider.of<PlayListProv>(context);
    memberProv = Provider.of<MemberProv>(context);
    searchProv = Provider.of<SearchProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);


    void setFollow(int? followerId, int? followingId) async {
      await followProv.setFollow(followerId, followingId);
    }

    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (trackProv.trackModel.searchTrackTotalCount! > searchTrackList.length) {
            if (comnLoadProv.shouldLoadMoreData(notification)) {
              comnLoadProv.loadMoreData(trackProv, "SearchTrack", searchTrackList.length,searchText: widget.searchText);
            }
          } else {
            if (comnLoadProv.isApiCall) {
              comnLoadProv.resetApiCallStatus();
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              FutureBuilder<bool>(
                  future: _getSearchMemberFuture, // 비동기 메소드 호출
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CustomProgressIndicatorItem());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('오류 발생: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('데이터가 없습니다.'));
                    } else {

                      MemberModelList memberModelList = memberProv.searchMemberModelList;

                      return Column(
                        children: [
                          if (memberModelList.memberList.length != 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Users',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                if (memberModelList.memberListCnt! > 4)
                                  GestureDetector(
                                    onTap: () async {
                                      GoRouter.of(context).push('/searchMember/${widget.searchText}');
                                    },
                                    child: Text(
                                      'more',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            for (int i = 0; i < (memberModelList.memberList.length > 6 ? 6 : memberModelList.memberList.length); i++)...[
                              FollowItem(
                                filteredFollowItem: memberModelList.memberList[i],
                                setFollow: setFollow,
                                isFollowingItem: false,
                                isSearch: true,
                              ),
                            ],
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ],
                      );
                    }
                }
              ),


              FutureBuilder<bool>(
              future: _getSearchPlayListFuture, // 비동기 메소드 호출
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CustomProgressIndicatorItem());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('오류 발생: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('데이터가 없습니다.'));
                    } else {

                      PlaylistList playListList = playListProv.playlists;
                      List<PlayListInfoModel> searchPlayList = playListList.playList;

                      return Column(
                      children: [
                        if (searchPlayList.length != 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PlayLists',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              if (playListList.searchPlayListTotalCount! > 8)
                                GestureDetector(
                                  onTap: () async {
                                    GoRouter.of(context).push('/searchPlayList/${widget.searchText}');
                                  },
                                  child: Text(
                                    'more',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification notification) {
                              return true;
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: PlayListSquareItem(
                                playList: searchPlayList,
                                isHome: false,
                                isAlbum : false,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ],
                    );
                  }
                }
              ),


              FutureBuilder<bool>(
              future: _getSearchTrackFuture, // 비동기 메소드 호출
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CustomProgressIndicatorItem());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('오류 발생: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('데이터가 없습니다.'));
                  } else {


                    Set<Track> searchTrackSet = searchTrackList.toSet();
                    List<Track> list = trackProv.trackModel.trackList;

                    trackProv.addUniqueTracksToList(
                      sourceList: list,
                      targetSet: searchTrackSet,
                      targetList: searchTrackList,
                      trackCd: "SearchTrackList",
                    );


                  return Column(
                    children: [
                      if (searchTrackList.length != 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Track',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        for (int i = 0; i < searchTrackList.length; i++) ...[
                          SizedBox(
                            height: 16,
                          ),
                          TrackListItem(
                            trackItem: searchTrackList[i],
                            trackItemIdx : i,
                            appScreenName: "SearchScreen",
                            isAudioPlayer: false,
                            initAudioPlayerTrackListCallBack: () async {

                              /**
                               * 검색의 경우 조회수 높은 순으로 100개 정도만?
                               * */

                              await trackProv.getSearchTrack(widget.searchText, comnLoadProv.listDataOffset, trackProv.trackModel.searchTrackTotalCount!);

                              trackProv.addUniqueTracksToList(
                                sourceList: list,
                                targetSet: searchTrackSet,
                                targetList: searchTrackList,
                                trackCd: "SearchTrackList",
                              );

                              List<int> trackIdList = searchTrackList.map((item) => int.parse(item.trackId.toString())).toList();
                              print(trackIdList.length);

                              trackProv.audioPlayerTrackList = searchTrackList;
                              await trackProv.setAudioPlayerTrackIdList(trackIdList);
                              trackProv.notify();




                          },)
                        ],
                      ],
                      CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall),
                    ],
                  );
                }
              }),


            ],
          ),
        ),
      ),
    );
  }
}
