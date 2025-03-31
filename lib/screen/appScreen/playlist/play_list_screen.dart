import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/more_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/modal/track/title_info_edit.dart';
import 'package:skrrskrr/screen/modal/track/track_info_edit.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
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
  late String? loginMemberId;
  bool isAuth = false;
  bool isEdit = false;

  late PlayListProv playListProv;
  late Future<bool> _getPlayListInitFuture;

  @override
  void initState() {
    print("PlayListScreen initstate");
    super.initState();
    _getPlayListInitFuture = Provider.of<PlayListProv>(context, listen: false).getPlayListInfo(widget.playListId,0);
    _loadMemberId();
  }

  void _loadMemberId() async {
    loginMemberId = await Helpers.getMemberId();
  }

  bool getIsAuth(checkMemberId)  {
    return checkMemberId == loginMemberId;
  }

  @override
  Widget build(BuildContext context) {

    playListProv = Provider.of<PlayListProv>(context);

    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        child: FutureBuilder<bool>(
          future: _getPlayListInitFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            PlaylistList playListList = playListProv.playlistList;
            isAuth = getIsAuth(playListList.playListInfoModel?.memberId.toString());

            return NotificationListener <ScrollNotification>(
                onNotification: (notification) {
              if (playListList.totalCount! > playListList.playListInfoModel!.playListTrackList!.length) {
                if (playListProv.shouldLoadMoreData(notification)) {
                  playListProv.loadMoreData();
                }
              } else {
                if (playListProv.isApiCall) {
                  playListProv.resetApiCallStatus();
                }
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Stack을 화면 상단에 배치
                  Container(
                    child: Stack(
                      // Stack이 자식 위젯이 화면을 벗어나도 클리핑하지 않도록 설정
                      children: [
                        // 배경 이미지
                        CustomCachedNetworkImage(imagePath: playListList.playListInfoModel!.playListImagePath, imageWidth: 100.w, imageHeight: 50.h),

                        Container(
                          width: 100.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9), // 하단은 어두운 색
                                Colors.transparent, // 상단은 투명
                              ],
                              stops: [0, 1.0],
                            ),
                          ),
                        ),

                        Positioned(
                          left: 30,
                          right: 30,
                          top: 30,
                          // bottom: 30,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CustomCachedNetworkImage(imagePath: playListList.playListInfoModel?.playListImagePath, imageWidth: 100.w, imageHeight: 40.h),
                          ),
                        ),

                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: CustomAppbar(
                              fnBackBtncallBack: () => {
                                GoRouter.of(context).pop()
                              },
                              fnUpdtBtncallBack:()=>{
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
                      ],
                    ),
                  ),



                  Container(
                    width: 100.w,
                    padding: EdgeInsets.only(left: 15 , right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              playListList.playListInfoModel!.playListNm!,
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
                                          title: playListList.playListInfoModel!.playListNm!,
                                          fncallBack:
                                              (String? newTitle) async {
                                            await playListProv
                                                .setPlayListInfo(playListList.playListInfoModel!.playListId!, newTitle!);
                                            setState(() {
                                            playListList.playListInfoModel!.playListNm =newTitle;
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
                        playListList.playListInfoModel!.memberNickName!,
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
                              '${playListList.playListInfoModel!.trackCnt ?? '0'} 곡',
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
                              playListList.playListInfoModel!.totalPlayTime!,
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
                                        playListProv.setPlayListLike(playListList.playListInfoModel!.playListId!);

                                        setState(() {
                                            playListList.playListInfoModel!.isPlayListLike = !playListList.playListInfoModel!.isPlayListLike!;

                                          if (playListList.playListInfoModel!.isPlayListLike!) {
                                              playListList.playListInfoModel!.playListLikeCnt = playListList.playListInfoModel!.playListLikeCnt! + 1;
                                          } else {
                                              playListList.playListInfoModel!.playListLikeCnt = playListList.playListInfoModel!.playListLikeCnt! - 1;
                                          }
                                        });
                                      },
                                      child: SvgPicture.asset(
                                            playListList.playListInfoModel!.isPlayListLike!
                                            ? 'assets/images/heart_red.svg'
                                            : 'assets/images/heart.svg',
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                          playListList.playListInfoModel!.playListLikeCnt
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
                        for (int i = 0; i < playListList.playListInfoModel!.playListTrackList!.length;
                        i++) ...[
                          TrackListItem(
                            trackItem:
                            playListList.playListInfoModel!.playListTrackList![i],
                          ),
                          SizedBox(height: 5,),
                        ]
                      ],
                    ),
                  ),

                  SizedBox(height: 100),

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
