import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class UploadTrackScreen extends StatefulWidget {
  const UploadTrackScreen({
    super.key,

  });


  @override
  State<UploadTrackScreen> createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends State<UploadTrackScreen> {

  late TrackList trackModel;
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool isApiCall = false;
  int listIndex = 0;

  @override
  Widget build(BuildContext context) {


    TrackProv trackProv = Provider.of<TrackProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);

    return Scaffold(
      body: FutureBuilder<bool>(
        future: !isLoading ? trackProv.getUploadTrack(0) : null, // 비동기 메소드 호출
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

          return Container(
            color: Color(0XFF1C1C1C),
            width: 100.w,
            height: 100.h,
            child: NotificationListener<ScrollNotification>(
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
                        await trackProv.getUploadTrack(listIndex);
                        await Future.delayed(Duration(seconds: 3));
                        setState(() {
                          isApiCall = false;
                        });
                      });
                    }
                    return true;
                  }
                } else {
                  isApiCall = true;
                }
                return false;
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50,),


                    Container(
                      padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                      child: CustomAppbar(
                        fnBackBtnCallBack: () => {Navigator.pop(context)},
                        fnUpdtBtnCallBack:()=>{},

                        title: "내 트랙",
                        isNotification : false,
                        isEditBtn: false,
                        isAddPlayListBtn : false,
                        isAddTrackBtn : true,
                        isAddAlbumBtn : false,
                      ),
                    ),
                    SizedBox(height: 25,),


                Wrap(
                  spacing: 30.0,
                  runSpacing: 20.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: trackModel.trackList.map((item) {
                    return TrackSquareItem(
                      track: item,
                      
                      bgColor: Colors.purpleAccent,
                    );
                  }).toList(),
                ),



                    SizedBox(height: 5),

                    if(isApiCall)
                      CircularProgressIndicator(
                        color: Color(0xffff0000),
                      ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
