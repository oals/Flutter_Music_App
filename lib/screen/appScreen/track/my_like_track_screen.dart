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
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class MyLikeTrackScreen extends StatefulWidget {
  const MyLikeTrackScreen({
    super.key,
  });


  @override
  State<MyLikeTrackScreen> createState() => _MyLikeTrackScreenState();
}

class _MyLikeTrackScreenState extends State<MyLikeTrackScreen> {
  late TrackProv trackProv;
  late Future<bool> _getLikeTrackInitFuture;
  late ComnLoadProv comnLoadProv;
  List<Track> likeTrackList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLikeTrackInitFuture = Provider.of<TrackProv>(context,listen: false,).getLikeTrack(0);
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
        height: 100.h,
        child: FutureBuilder<bool>(
          future: _getLikeTrackInitFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            }

            TrackList trackModel = trackProv.trackModel;

            Set<Track> likeTrackSet = likeTrackList.toSet();
            List<Track> list = trackProv.trackModel.trackList;

            trackProv.addUniqueTracksToList(
              sourceList: list,
              targetSet: likeTrackSet,
              targetList: likeTrackList,
              trackCd: 9,
            );



            return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (trackModel.likeTrackTotalCount! > likeTrackList.length) {
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


              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppbar(
                      fnBackBtncallBack: () => {GoRouter.of(context).pop()},
                      fnUpdtBtncallBack:()=>{},
                      title: "Liked Track",
                      isNotification : false,
                      isEditBtn: false,
                      isAddPlayListBtn : false,
                      isAddTrackBtn : false,
                      isAddAlbumBtn : false,
                    ),
                    SizedBox(
                      height: 20,
                    ),


                    Wrap(
                      spacing: 30.0,
                      runSpacing: 20.0,
                      alignment: WrapAlignment.spaceBetween,
                      children: likeTrackList.map((item) {
                        return TrackSquareItem(
                          track: item,
                          bgColor: Colors.red,
                        );
                      }).toList(),
                    ),

                    CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
