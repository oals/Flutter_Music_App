import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/modal/track/title_info_edit.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({
    super.key,
    required this.playList,
  });

  final PlayListInfoModel playList;

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  late String? loginMemberId;
  bool isAuth = false;
  bool isEdit = false;

  late PlayListProv playListProv;
  late ComnLoadProv comnLoadProv;
  late TrackProv trackProv;
  late Future<bool> _getPlayListInitFuture;
  late Future<bool> _getPlayListTrackInitFuture;
  List<Track> trackList = [];

  @override
  void initState() {
    print("PlayListScreen initstate");
    super.initState();
    _getPlayListInitFuture = Provider.of<PlayListProv>(context, listen: false).getPlayListInfo(widget.playList.playListId!);
    _getPlayListTrackInitFuture = Provider.of<TrackProv>(context, listen: false).getPlayListTrackList(widget.playList.playListId!,0);
    _loadMemberId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    comnLoadProv.clear();
    super.dispose();
  }

  void _loadMemberId() async {
    loginMemberId = await Helpers.getMemberId();
  }


  @override
  Widget build(BuildContext context) {
    comnLoadProv = Provider.of<ComnLoadProv>(context);
    playListProv = Provider.of<PlayListProv>(context);
    trackProv = Provider.of<TrackProv>(context);


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

            //호출되어서 리빌드해도 이전 값을 가지게 됨
            widget.playList.updateApiData(playListProv.playListInfoModel);
            playListProv.playListInfoModel = widget.playList;
            isAuth = Helpers.getIsAuth(widget.playList.memberId.toString(),loginMemberId!);

            return NotificationListener <ScrollNotification>(onNotification: (notification) {

              if (widget.playList.trackCnt! >  trackList.length) {
                if (comnLoadProv.shouldLoadMoreData(notification)) {
                  comnLoadProv.loadMoreData(trackProv, 'PlayListTrackList', trackList.length, playListId: widget.playList.playListId);
                }
              } else {
                if (comnLoadProv.isApiCall) {
                  comnLoadProv.resetApiCallStatus();
                }
              }
              return false;
            },
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                      child: Stack(
                        children: [
                          CustomCachedNetworkImage(imagePath: widget.playList.playListImagePath, imageWidth: 100.w, imageHeight: 50.h,isBoxFit: true,),

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
                              child: CustomCachedNetworkImage(imagePath: widget.playList.playListImagePath, imageWidth: 100.w, imageHeight: 40.h,isBoxFit: true,),
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
                                widget.playList.playListNm!,
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
                                    print('플리 소개 편집 버튼');
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: TitleInfoEditModal(
                                            title: widget.playList.playListNm!,
                                            fnCallBack: (String? newTitle) async {
                                              await playListProv.setPlayListInfo(widget.playList.playListId!, newTitle!);
                                              widget.playList.playListNm = newTitle;
                                              setState(() {});
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

                          Row(
                            children: [
                              ClipOval(
                                child: CustomCachedNetworkImage(
                                    imagePath: widget.playList.memberImagePath,
                                    imageWidth: 4.5.w,
                                    imageHeight: null,
                                  isBoxFit: true,
                                ),
                              ),
                              SizedBox(width: 3,),
                              Text(
                                widget.playList.memberNickName!,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                '${widget.playList.trackCnt ?? '0'} tracks',
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
                                widget.playList.totalPlayTime!,
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
                                          playListProv.setPlayListLike(widget.playList.playListId!);
                                          print(widget.playList.isPlayListLike );
                                          widget.playList.isPlayListLike = !widget.playList.isPlayListLike!;

                                          if (widget.playList.isPlayListLike!) {
                                            widget.playList.playListLikeCnt = widget.playList.playListLikeCnt! + 1;
                                          } else {
                                            widget.playList.playListLikeCnt = widget.playList.playListLikeCnt! - 1;
                                          }

                                          print(widget.playList.isPlayListLike );

                                          setState(() {});
                                        },
                                        child: SvgPicture.asset(
                                          widget.playList.isPlayListLike!
                                              ? 'assets/images/heart_red.svg'
                                              : 'assets/images/heart.svg',
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        widget.playList.playListLikeCnt
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


                          FutureBuilder<bool>(
                              future: _getPlayListTrackInitFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else {

                                  trackList = trackProv.trackListFilter("PlayListTrackList");

                                  return Column(
                                    children: [
                                      for(int i = 0; i < trackList.length; i++)...[
                                        TrackListItem(
                                          trackItem: trackList[i],
                                          isAudioPlayer: false,
                                          callBack: () async {
                                                List<int> trackIdList = trackList.map((item) => int.parse(item.trackId.toString())).toList();
                                                await trackProv.setAudioPlayerTrackIdList(trackIdList);
                                              },
                                        ),
                                        SizedBox(height: 5,),
                                      ]
                                    ],
                                  );

                               }
                              }
                             ),

                        ],
                      ),
                    ),


                    CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall)


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
