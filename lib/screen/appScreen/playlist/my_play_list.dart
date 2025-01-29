import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';

class MyPlayListScreen extends StatefulWidget {
  const MyPlayListScreen({
    super.key,
  });

  @override
  State<MyPlayListScreen> createState() => _MyPlayListScreenState();
}

class _MyPlayListScreenState extends State<MyPlayListScreen> {
  late PlaylistList playListModel;

  bool isLoading = false;
  bool isApiCall = false;
  int listIndex = 0;


  @override
  Widget build(BuildContext context) {
    PlayListProv playListProv = Provider.of<PlayListProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);

    return Scaffold(
      body: FutureBuilder<bool>(
        future: !isLoading ? playListProv.getPlayList(0,0,false) : null, // 비동기 메소드 호출
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('데이터가 없습니다.'));
          }

          playListModel = playListProv.playlistList;
          isLoading = true;


          return Container(
            height: 100.h,
            color: Color(0xff1c1c1c),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (playListModel.totalCount! > playListModel.playList.length) {
                  print('스크롤1');
                  // 스크롤이 끝에 도달했을 때
                  if (notification is ScrollUpdateNotification &&
                      notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                    print('스크롤2');
                    if (!isApiCall) {
                      Future(() async {
                        setState(() {
                          isApiCall = true;
                        });
                        listIndex = listIndex + 20;
                        print('더가져오기');
                        await playListProv.getPlayList(0,listIndex,false);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                            child: CustomAppbar(
                              fnBackBtnCallBack: () => {Navigator.pop(context)},
                              fnUpdtBtnCallBack:()=>{},
                              title: "플레이리스트",
                              isNotification : false,
                              isEditBtn: false,
                              isAddPlayListBtn : true,
                              isAddTrackBtn : false,
                              isAddAlbumBtn : false,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          PlayListSquareItem(
                            playList: playListModel.playList,
                          ),
                        ],
                      ),
                    ),
                    if (isApiCall)
                      CircularProgressIndicator(
                        color: Color(0xffff0000),
                      ),
                    SizedBox(
                      height: 90,
                    ),
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
