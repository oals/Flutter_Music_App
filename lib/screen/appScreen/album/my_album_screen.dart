import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';

class MyAlbumScreen extends StatefulWidget {
  const MyAlbumScreen({
    super.key,
    required this.adminId,
  });

  final int? adminId;

  @override
  State<MyAlbumScreen> createState() => _MyAlbumScreenState();
}

class _MyAlbumScreenState extends State<MyAlbumScreen> {
  late PlaylistList playListModel;

  bool isLoading = false;
  bool isApiCall = false;
  int listIndex = 0;



  @override
  Widget build(BuildContext context) {
    PlayListProv playListProv = Provider.of<PlayListProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);


    return Scaffold(
      body: Container(
        height: 100.h,
        color: Color(0xff1c1c1c),
        child: FutureBuilder<bool>(
          future: !isLoading ? playListProv.getPlayList(0,0,true) : null, // 비동기 메소드 호출
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


            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (playListModel.totalCount! > playListModel.playList.length) {
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
                        await playListProv.getPlayList(0,listIndex,true);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAppbar(
                            fnBackBtncallBack: () => {Navigator.pop(context)},
                            fnUpdtBtncallBack:()=>{},
                            title: "내 앨범",
                            isNotification : false,
                            isEditBtn: false,
                            isAddPlayListBtn : false,
                            isAddAlbumBtn : true,
                            isAddTrackBtn : false,
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
                    if (isApiCall)...[
                      SizedBox(height: 10,),
                      CircularProgressIndicator(
                        color: Color(0xffff0000),
                      ),
                    ],
                    SizedBox(
                      height: 90,
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
