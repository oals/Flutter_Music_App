import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';

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

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {


    PlayListProv playListProv = Provider.of<PlayListProv>(context);

    ImageProv imageProv = Provider.of<ImageProv>(context);

    print('myplaylist빌드');

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff2d1640), // 상단의 연한 색 (색상값을 조정하세요)
            Color(0xff8515e7), // 하단의 어두운 색 (현재 색상)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff2d1640), // 상단의 연한 색
              Color(0xffffe00),    // 하단의 어두운 색
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: FutureBuilder<bool>(
          future: !isLoading ? playListProv.getPlayList(widget.trackId,0) : null, // 데이터를 가져오는 함수
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터 로딩 중
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // 에러 발생
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              // 데이터가 없거나 비어있는 경우
              return Center(child: Text('플레이리스트가 없습니다.'));
            }

            PlaylistList playListModel = playListProv.playlistList;
            isLoading = true;

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
                        childAspectRatio: 0.6,
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
                                 ClipRRect(
                                   borderRadius: BorderRadius.circular(15.0), // 원하는 둥글기 조정
                                   child: CachedNetworkImage(
                                     imageUrl: imageProv.imageLoader(playListModel.playList[index].playListImagePath),  // 이미지 URL
                                     placeholder: (context, url) {
                                       
                                       return CircularProgressIndicator();  // 로딩 중에 표시할 위젯
                                     },
                                     errorWidget: (context, url, error) {
                                       print('이미지 로딩 실패: $error');
                                       return Icon(Icons.error);  // 로딩 실패 시 표시할 위젯
                                     },
                                     fadeInDuration: Duration(milliseconds: 500),  // 이미지가 로드될 때 페이드 인 효과
                                     fadeOutDuration: Duration(milliseconds: 500),  // 이미지가 사라질 때 페이드 아웃 효과
                                     width: 30.w,  // 이미지의 가로 크기
                                     height: 18.h,  // 이미지의 세로 크기
                                     fit: BoxFit.cover,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
                                     imageBuilder: (context, imageProvider) {
                                       
                                       return Image(image: imageProvider);  // 이미지가 로드되면 표시
                                     },
                                   ),

                                 ),
                              Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          playListModel.playList[index].playListNm ?? "", // 데이터의 이름을 표시
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      if(playListModel.playList[index].isPlayListPrivacy == true)...[
                                        // SizedBox(width: 5,),
                                        Icon(Icons.lock_sharp,size: 14,color: Colors.white,),
                                      ],
                                    ],
                                  ),


                                  if(playListModel.playList[index].isInPlayList == true)
                                    Text('이미 추가됨',style: TextStyle(color: Colors.white,fontSize: 13),),
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
      ),
    );
  }
}
