import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/comn/messages/empty_message_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_item.dart';

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
    super.initState();
    _getUploadInitFuture = Provider.of<TrackProv>(context, listen: false).getUploadTrack(0,20);
  }

  @override
  void dispose() {
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
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            TrackList trackListModel = trackProv.trackListModel;
            Set<Track> uploadTrackSet = uploadTrackList.toSet();
            List<Track> list = trackProv.trackListModel.trackList;

            trackProv.addUniqueTracksToList(
              sourceList: list,
              targetSet: uploadTrackSet,
              targetList: uploadTrackList,
              trackCd: "UploadTrackList",
            );

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (trackListModel.uploadTrackTotalCount! > uploadTrackList.length) {
                  if (comnLoadProv.shouldLoadMoreData(notification)) {
                    comnLoadProv.loadMoreData(trackProv, "UploadTrack", uploadTrackList.length);
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
                      fnUpdateBtnCallBack:()=>{},
                      title: "Uploaded Tracks",
                      isNotification : false,
                      isEditBtn: false,
                      isAddTrackBtn : true,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          if (uploadTrackList.length == 0)
                            EmptyMessageItem(paddingHeight: 30.h),

                          for (int i = 0 ; i < uploadTrackList.length; i++)...[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8),
                              child: TrackItem(
                                trackItem: uploadTrackList[i],
                                trackItemIdx : i,
                                appScreenName: "UploadTrackScreen",
                                isAudioPlayer: false,
                                initAudioPlayerTrackListCallBack: () async {

                                  await trackProv.getUploadTrack(comnLoadProv.listDataOffset, trackListModel.uploadTrackTotalCount!);

                                  trackProv.addUniqueTracksToList(
                                    sourceList: list,
                                    targetSet: uploadTrackSet,
                                    targetList: uploadTrackList,
                                    trackCd: "UploadTrackList",
                                  );

                                  List<int> trackIdList = uploadTrackList.map((item) => int.parse(item.trackId.toString())).toList();

                                  trackProv.audioPlayerTrackList = List.from(uploadTrackList);
                                  trackProv.setAudioPlayerTrackIdList(trackIdList);
                                  trackProv.notify();
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],


                          SizedBox(height: 5),

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
