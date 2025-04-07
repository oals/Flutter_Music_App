import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';

class MyPlayListModalScreen extends StatefulWidget {
  const MyPlayListModalScreen({
    super.key,
    required this.trackId,
  });

  final int trackId;

  @override
  State<MyPlayListModalScreen> createState() => _MyPlayListModalScreenState();
}

class _MyPlayListModalScreenState extends State<MyPlayListModalScreen> {
  late PlayListProv playListProv;
  late Future<bool> _getPlayListInitFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPlayListInitFuture = Provider.of<PlayListProv>(context,listen: false).getPlayList(widget.trackId,0,false);
  }

  @override
  Widget build(BuildContext context) {

    playListProv = Provider.of<PlayListProv>(context);

    return Container(
      height: 70.h,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: FutureBuilder<bool>(
        future: _getPlayListInitFuture, // 데이터를 가져오는 함수
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('플레이리스트가 없습니다.'));
          }

          PlaylistList playListModel = playListProv.playlistList;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '내 플레이리스트',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(Icons.add_circle, color: Colors.white),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: 90.w,
                  height: 70.h,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: playListModel.playList.length, // 데이터 길이 사용
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if(playListModel.playList[index].isInPlayList == true){
                            Fluttertoast.showToast(
                              msg: "이미 재생목록에 추가되어 있습니다.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }else {
                            Navigator.of(context).pop(playListModel.playList[index].playListId); // 선택한 데이터 반환
                          }
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey,width: 3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0), // 원하는 둥글기 조정
                                    child: CustomCachedNetworkImage(
                                        imagePath:playListModel.playList[index].playListImagePath,
                                        imageWidth : 30.w,
                                        imageHeight : 14.h
                                    ),

                                  ),
                                ),


                                if(playListModel.playList[index].isInPlayList == true)
                                  Positioned(
                                    top : 0,
                                    left : 0,
                                    right : 0,
                                    bottom : 0,
                                    child: Container(
                                      width: 30.w,
                                      height: 14.h,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.7), // 하단은 어두운 색
                                            Colors.transparent, // 상단은 투명
                                          ],
                                          stops: [1.0, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),

                                Positioned(
                                    top: 15,
                                    right : 5,
                                    child: playListModel.playList[index].isPlayListPrivacy == true ?
                                    Icon(Icons.lock_sharp,size: 20,color: Colors.white,) :
                                    SizedBox(),
                                )
                              ],
                            ),




                            Column(
                              children: [
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    SizedBox(width: 2.5.w,),
                                    Expanded(
                                      child: Text(
                                        playListModel.playList[index].playListNm ?? "", // 데이터의 이름을 표시
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            overflow: TextOverflow.ellipsis
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),

                                  ],
                                ),



                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
