import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/modal/track/title_info_edit.dart';
import 'package:skrrskrr/screen/modal/track/track_info_edit.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({
    super.key,
    required this.playListId,
    
    
  });

  final int playListId;
  
  

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  late String? memberId;
  bool isAuth = false;
  bool isEdit = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMemberId();
  }

  void _loadMemberId() async {
    memberId = await Helpers.getMemberId();
  }

  @override
  Widget build(BuildContext context) {

    PlayListProv playListProv = Provider.of<PlayListProv>(context);

    ImageProv imageProv = Provider.of<ImageProv>(context);

    return Scaffold(
      body: FutureBuilder<bool>(
        future:
            !isLoading ? playListProv.getPlayListInfo(widget.playListId) : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          PlayListInfoModel playListModel = playListProv.modelPlayInfo;

          if (playListModel.memberId.toString() == memberId) {
            isAuth = true;
          }

          isLoading = true;

          return Container(
            // 전체 컨테이너의 크기를 지정하거나 부모 위젯의 크기를 채울 수 있게 설정
            width: 100.w,
            height: 100.h,
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Stack을 화면 상단에 배치
                  Container(
                    height: 200.h,
                    child: Stack(
                      // Stack이 자식 위젯이 화면을 벗어나도 클리핑하지 않도록 설정
                      children: [
                        // 배경 이미지
                        Image.asset(
                          'assets/images/testImage.png',
                          width: 100.w,
                          height: 50.h,
                          fit: BoxFit.cover, // 이미지가 영역을 꽉 채우도록 설정
                        ),

                        // 그라데이션 오버레이
                        Container(
                          width: 100.w,
                          height: 50.h,
                          decoration: BoxDecoration(
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

                        Positioned(
                            top: 50,
                            left: 10,
                            right: 10,
                            child: CustomAppbar(
                              fnBackBtnCallBack: () => {Navigator.pop(context)},
                              fnUpdtBtnCallBack:()=>{
                                setState(() {
                                  isEdit = !isEdit;
                                }),
                              },
                              
                              title: "",
                              isNotification : true,
                              isEditBtn: isAuth,
                              isAddPlayListBtn : false,
                              isAddTrackBtn : false,
                              isAddAlbumBtn : false,
                            )),

                        // 상단에 위치한 텍스트와 버튼들
                        Positioned(
                          left: 55,
                          right: 55,
                          top: 55,
                          // bottom: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/images/testImage.png',
                              width: 100.w,
                              height: 40.h,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 44.h,
                          left: 10,
                          child: Container(
                            width: 100.w,
                            padding: EdgeInsets.only(left: 0, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      playListModel.playListNm!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if(isEdit)...[
                                      SizedBox(width: 3),
                                      GestureDetector(
                                        onTap: () {
                                          print('음원 소개 편집 버튼');
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              return Dialog(
                                                backgroundColor: Colors.transparent,
                                                child: TitleInfoEditModal(
                                                  title: playListModel.playListNm!,
                                                  fnCallBack:
                                                      (String? newTitle) async {
                                                    await playListProv
                                                        .setPlayListInfo(playListModel.playListId!, newTitle!);
                                                    setState(() {
                                                      playListModel.playListNm =
                                                          newTitle;
                                                    });
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/edit.svg',
                                          width: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],

                                  ],
                                ),
                                SizedBox(height: 2),
                                Text(
                                  playListModel.memberNickName!,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      '${playListModel.trackCnt ?? '0'} 곡',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: SvgPicture.asset(
                                        'assets/images/circle.svg',
                                        color: Colors.grey,
                                        width: 15,
                                        height: 10,
                                      ),
                                    ),
                                    Text(
                                      playListModel.totalPlayTime!,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/share.svg',
                                          width: 23,
                                          height: 23,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                print('플리 좋아요');
                                                playListProv.setPlayListLike(playListModel.playListId!);

                                                setState(() {
                                                  playListModel.playListLike = !playListModel.playListLike!;

                                                  if (playListModel.playListLike!) {
                                                    playListModel.playListLikeCnt = playListModel.playListLikeCnt! + 1;
                                                  } else {
                                                    playListModel.playListLikeCnt = playListModel.playListLikeCnt! - 1;
                                                  }
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                playListModel.playListLike!
                                                    ? 'assets/images/heart_red.svg'
                                                    : 'assets/images/heart.svg',
                                              ),
                                            ),
                                            SizedBox(width: 2),
                                            Text(
                                              playListModel.playListLikeCnt
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SvgPicture.asset(
                                          'assets/images/repeat.svg',
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SvgPicture.asset(
                                          'assets/images/more.svg',
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white, // 테두리 색상
                                          width: 3.0, // 테두리 두께
                                        ),
                                        shape: BoxShape.circle, // 원형으로 설정
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/images/play_circle.svg',
                                        width: 4.5.w,
                                        height: 4.5.h,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                for (int i = 0;
                                    i < playListModel.trackCnt!;
                                    i++) ...[
                                  TrackListItem(
                                    trackItem:
                                        playListModel.playListTrackList![i],
                                  ),
                                  SizedBox(height: 5,),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
