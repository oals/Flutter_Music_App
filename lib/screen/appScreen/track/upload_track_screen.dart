import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';

class UploadTrackScreen extends StatefulWidget {
  const UploadTrackScreen({
    super.key,
  });

  @override
  State<UploadTrackScreen> createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends State<UploadTrackScreen> {

  late Future<bool> _getUploadInitFuture;
  late TrackProv trackProv;
  late ComnLoadProv comnLoadProv;
  List<Track> uploadTrackList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUploadInitFuture = Provider.of<TrackProv>(context, listen: false).getUploadTrack(0);
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
          future: _getUploadInitFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            }

            TrackList trackModel = trackProv.trackModel;
            Set<Track> uploadTrackSet = uploadTrackList.toSet();
            List<Track> list = trackProv.trackModel.trackList;

            trackProv.addUniqueTracksToList(
              sourceList: list,
              targetSet: uploadTrackSet,
              targetList: uploadTrackList,
              trackCd: "UploadTrackList",
            );

            // uploadTrackList.sort((a, b) => b.trackId!.compareTo(a.trackId!));

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (trackModel.uploadTrackTotalCount! > uploadTrackList.length) {
                  if (comnLoadProv.shouldLoadMoreData(notification)) {
                    comnLoadProv.loadMoreData(trackProv, "UploadTrack", uploadTrackList.length);
                  }
                } else {
                  if(comnLoadProv.isApiCall){
                    comnLoadProv.resetApiCallStatus();
                  }
                }
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    CustomAppbar(
                      fnBackBtncallBack: () => {GoRouter.of(context).pop()},
                      fnUpdtBtncallBack:()=>{},
                      title: "Uploaded Tracks",
                      isNotification : false,
                      isEditBtn: false,
                      isAddPlayListBtn : false,
                      isAddTrackBtn : true,
                      isAddAlbumBtn : false,
                    ),
                    SizedBox(height: 25,),


                    Wrap(
                      spacing: 30.0,
                      runSpacing: 20.0,
                      alignment: WrapAlignment.spaceBetween,
                      children: uploadTrackList.map((item) {
                        return TrackSquareItem(
                          track: item,
                          bgColor: Colors.purpleAccent,
                        );
                      }).toList(),
                    ),


                    SizedBox(height: 5),

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
