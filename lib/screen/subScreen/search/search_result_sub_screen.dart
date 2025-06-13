import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/member/member_model_list.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/comn/messages/empty_message_item.dart';
import 'package:skrrskrr/screen/subScreen/follow/follow_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/playlist_square_item.dart';


class SearchResultSubScreen extends StatefulWidget {
  const SearchResultSubScreen({
    super.key,
    required this.searchText,
  });

  final String searchText;

  @override
  State<SearchResultSubScreen> createState() => _SearchResultSubScreenState();
}

class _SearchResultSubScreenState extends State<SearchResultSubScreen> {
  late FollowProv followProv;
  late TrackProv trackProv;
  late PlayListProv playListProv;
  late MemberProv memberProv;
  late SearchProv searchProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool> _getSearchTrackFuture;
  late Future<bool> _getSearchPlayListFuture;
  late Future<bool> _getSearchAlbumFuture;
  late Future<bool> _getSearchMemberFuture;
  late Future<List<bool>> _cachedFuture;
  List<Track> searchTrackList = [];
  List<PlayListInfoModel> searchPlayList = [];
  List<PlayListInfoModel> searchAlbum = [];
  MemberModelList memberModelList = MemberModelList();

  @override
  void initState() {
    super.initState();

    _getSearchTrackFuture = Provider.of<TrackProv>(context, listen: false).getSearchTrack(widget.searchText,0,20);
    _getSearchPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getSearchPlayList(widget.searchText,0, 8, false);
    _getSearchAlbumFuture = Provider.of<PlayListProv>(context, listen: false).getSearchPlayList(widget.searchText,0, 8, true);
    _getSearchMemberFuture = Provider.of<MemberProv>(context, listen: false).getSearchMember(widget.searchText,0, 6);

    _cachedFuture = Future.wait([
      _getSearchPlayListFuture,
      _getSearchMemberFuture,
      _getSearchTrackFuture,
      _getSearchAlbumFuture,
    ]);
  }

  @override
  void dispose() {
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
          if (trackProv.trackListModel.searchTrackTotalCount! > searchTrackList.length) {
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

              FutureBuilder<List<bool>>(
                  future: _cachedFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(padding: EdgeInsets.only(top: 30.h), child: CustomProgressIndicatorItem());
                    } else {

                      memberModelList = memberProv.searchMemberModelList;

                      PlaylistList playListList = playListProv.playlists;
                      searchPlayList = playListList.playList;

                      PlaylistList albumList = playListProv.albums;
                      searchAlbum = albumList.playList;

                      Set<Track> searchTrackSet = searchTrackList.toSet();
                      List<Track> list = trackProv.trackListModel.trackList;

                      trackProv.addUniqueTracksToList(
                        sourceList: list,
                        targetSet: searchTrackSet,
                        targetList: searchTrackList,
                        trackCd: "SearchTrackList",
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          if (searchTrackList.length == 0 && searchPlayList.length == 0 && memberModelList.memberList.length == 0)
                            EmptyMessageItem(paddingHeight: 30.h),

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

                          if (searchAlbum.length != 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Albums',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                if (albumList.searchPlayListTotalCount! > 8)
                                  GestureDetector(
                                    onTap: () async {
                                      GoRouter.of(context).push('/searchAlbumList/${widget.searchText}');
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
                                child: PlaylistSquareItem(
                                  playList: searchAlbum,
                                  isHome: false,
                                  isAlbum : false,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],

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
                                child: PlaylistSquareItem(
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
                              TrackItem(
                                trackItem: searchTrackList[i],
                                trackItemIdx : i,
                                appScreenName: "SearchScreen",
                                isAudioPlayer: false,
                                initAudioPlayerTrackListCallBack: () async {

                                  await trackProv.getSearchTrack(widget.searchText, comnLoadProv.listDataOffset, trackProv.trackListModel.searchTrackTotalCount!);

                                  trackProv.addUniqueTracksToList(
                                    sourceList: list,
                                    targetSet: searchTrackSet,
                                    targetList: searchTrackList,
                                    trackCd: "SearchTrackList",
                                  );

                                  List<int> trackIdList = searchTrackList.map((item) => int.parse(item.trackId.toString())).toList();

                                  trackProv.audioPlayerTrackList = List.from(searchTrackList);
                                  trackProv.setAudioPlayerTrackIdList(trackIdList);
                                  trackProv.notify();
                                },),
                            ],
                          ],
                          Center(child: CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall)),

                        ],
                      );
                    }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
