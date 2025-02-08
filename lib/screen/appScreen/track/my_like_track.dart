import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
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
  late TrackList trackModel;
  bool isLoading = false;
  bool isApiCall = false;
  int listIndex = 0;

  @override
  Widget build(BuildContext context) {
    TrackProv trackProv = Provider.of<TrackProv>(context);

    return Scaffold(
      body: Container(
        color: Color(0xff1c1c1c),
        height: 100.h,
        child: FutureBuilder<bool>(
          future: !isLoading ? trackProv.getLikeTrack(0) : null, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            }

            trackModel = trackProv.trackModel;
            isLoading = true;

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (trackModel.totalCount! > trackModel.trackList.length) {
                  // 스크롤이 끝에 도달했을 때
                  if (notification is ScrollUpdateNotification &&
                      notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                    if (!isApiCall) {
                      Future(() async {
                        setState(() {
                          isApiCall = true;
                        });
                        listIndex = listIndex + 20;
                        await trackProv.getLikeTrack(listIndex);
                        await Future.delayed(Duration(seconds: 3));
                        setState(() {
                          isApiCall = false;
                        });
                      });
                    }
                  }
                } else {
                  isApiCall = false;
                }
                return false;
              },


              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppbar(
                      fnBackBtncallBack: () => {Navigator.pop(context)},
                      fnUpdtBtncallBack:()=>{},
                      title: "관심 트랙",
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
                      children: trackModel.trackList.map((item) {
                        return TrackSquareItem(
                          track: item,

                          bgColor: Colors.red,
                        );
                      }).toList(),
                    ),
                    if (isApiCall)...[
                      SizedBox(height: 10,),
                      CircularProgressIndicator(
                        color: Color(0xffff0000),
                      ),
                    ],
                    SizedBox(
                      height: 80,
                    ),
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
