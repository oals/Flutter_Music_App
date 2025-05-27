import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/track/track_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

import '../../../prov/player_prov.dart';

class LikeTrackScreen extends StatefulWidget {
  const LikeTrackScreen({
    super.key,
  });

  @override
  State<LikeTrackScreen> createState() => _LikeTrackScreenState();
}

class _LikeTrackScreenState extends State<LikeTrackScreen> {
  late TrackProv trackProv;
  late Future<bool> _getLikeTrackInitFuture;
  late ComnLoadProv comnLoadProv;
  List<Track> likeTrackList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLikeTrackInitFuture = Provider.of<TrackProv>(
      context,
      listen: false,
    ).getLikeTrack(0, 20);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    comnLoadProv.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trackProv = Provider.of<TrackProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);

    return Scaffold(
      body: Container(
        color: Colors.black,
        width: 100.w,
        height: 100.h,
        child: FutureBuilder<bool>(
          future: _getLikeTrackInitFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            }

            TrackList trackListModel = trackProv.trackListModel;

            Set<Track> likeTrackSet = likeTrackList.toSet();
            List<Track> list = trackProv.trackListModel.trackList;

            trackProv.addUniqueTracksToList(
              sourceList: list,
              targetSet: likeTrackSet,
              targetList: likeTrackList,
              trackCd: "MyLikeTrackList",
            );

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (trackListModel.likeTrackTotalCount! > likeTrackList.length) {
                  if (comnLoadProv.shouldLoadMoreData(notification)) {
                    comnLoadProv.loadMoreData(trackProv, "LikeTrack", likeTrackList.length);
                  }
                } else {
                  if (comnLoadProv.isApiCall) {
                    comnLoadProv.resetApiCallStatus();
                  }
                }
                return false;
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CustomAppbar(
                      fnBackBtnCallBack: () => {GoRouter.of(context).pop()},
                      fnUpdateBtnCallBack: () => {},
                      title: "Liked Track",
                      isNotification: false,
                      isEditBtn: false,
                      isAddTrackBtn: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          for (int i = 0; i < likeTrackList.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                              child: TrackItem(
                                trackItem: likeTrackList[i],
                                trackItemIdx : i,
                                isAudioPlayer: false,
                                appScreenName: "LikeTrackScreen",
                                initAudioPlayerTrackListCallBack: () async {

                                  await trackProv.getLikeTrack(comnLoadProv.listDataOffset, trackListModel.likeTrackTotalCount!);

                                  trackProv.addUniqueTracksToList(
                                    sourceList: list,
                                    targetSet: likeTrackSet,
                                    targetList: likeTrackList,
                                    trackCd: "MyLikeTrackList",
                                  );

                                  List<int> trackIdList = likeTrackList.map((item) => int.parse(item.trackId.toString())).toList();

                                  trackProv.audioPlayerTrackList = List.from(likeTrackList);
                                  trackProv.setAudioPlayerTrackIdList(trackIdList);
                                  trackProv.notify();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                          CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
