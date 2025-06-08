import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/comn/messages/empty_message_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/playlist_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/utils/comn_utils.dart';


class MemberPageScreen extends StatefulWidget {
  const MemberPageScreen({
    super.key,
    required this.memberId,
  });

  final int memberId;

  @override
  State<MemberPageScreen> createState() => _MemberPageScreenState();
}

class _MemberPageScreenState extends State<MemberPageScreen> {
  bool isAuth = false;
  bool isEdit = false;
  late MemberProv memberProv;
  late TrackProv trackProv;
  late ImageProv imageProv;

  late String? loginMemberId;
  late Future<bool> _getUserInitFuture;
  late Future<bool> _getUserTrackFuture;
  late Future<bool> _getUserPlayListFuture;
  late Future<bool> _getUserAlbumFuture;
  late ComnLoadProv comnLoadProv;
  late PlayListProv playListProv;

  @override
  void initState() {
    print("UserPageScreen initstate");
    super.initState();
    _getUserInitFuture = Provider.of<MemberProv>(context, listen: false).getMemberPageInfo(widget.memberId);
    _getUserPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getMemberPagePlayList(widget.memberId,0,7);
    _getUserAlbumFuture = Provider.of<PlayListProv>(context, listen: false).getMemberPageAlbum(widget.memberId,0,7);
    _getUserTrackFuture = Provider.of<TrackProv>(context, listen: false).getMemberPageTrack(widget.memberId);
    _loadMemberId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    comnLoadProv.clear();
    super.dispose();
  }

  void _loadMemberId() async {
    loginMemberId = await ComnUtils.getMemberId();
  }

  @override
  Widget build(BuildContext context) {
    memberProv = Provider.of<MemberProv>(context);
    playListProv = Provider.of<PlayListProv>(context);
    trackProv = Provider.of<TrackProv>(context);
    imageProv = Provider.of<ImageProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);

    void setNewTitle(int cd, String newTitle) async {
      if (cd == 1) {
        await memberProv.fnMemberInfoUpdate(memberNickName: newTitle);
        memberProv.model.memberNickName = newTitle;
      } else if (cd == 2) {
        await memberProv.fnMemberInfoUpdate(memberInfo: newTitle);
        memberProv.model.memberInfo = newTitle;
      }
      setState(() {});
    }

    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: FutureBuilder<bool>(
          future: _getUserInitFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else {

              MemberModel memberModel = memberProv.model;
              isAuth = ComnUtils.getIsAuth(memberModel.memberId.toString(), loginMemberId!);

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (trackProv.trackListModel.allTrackTotalCount! > trackProv.memberTrackList.length) {
                    if (comnLoadProv.shouldLoadMoreData(notification)) {
                      comnLoadProv.loadMoreData(trackProv, 'MemberPageTrack', trackProv.memberTrackList.length, memberId: widget.memberId);
                    }
                  } else {
                    comnLoadProv.resetApiCallStatus();

                  }
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CustomCachedNetworkImage(
                            imagePath: memberModel.memberImagePath,
                            imageWidth: 100.w,
                            imageHeight: 50.h,
                            isBoxFit: true,
                          ),

                          Container(
                            width: 100.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter, // 하단부터
                                end: Alignment.topCenter, // 상단까지
                                colors: [
                                  Colors.black.withOpacity(0.9), // 하단은 어두운 색
                                  Colors.transparent, // 상단은 투명
                                ],
                                stops: [0.0, 1.0], // 그라데이션이 아래에서 위로 변하도록
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isEdit) ...[
                                  GestureDetector(
                                    onTap: () async {
                                      String? newMemberImagePath = await ComnUtils.pickImage(memberModel.memberId, true, context);
                                      if (newMemberImagePath != null) {
                                        memberModel.memberImagePath = newMemberImagePath;
                                        setState(() {});
                                      }
                                    },
                                    child: Text(
                                      'Change Image',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: CustomAppbar(
                              fnBackBtnCallBack: () => {
                                GoRouter.of(context).pop()
                              },
                              fnUpdateBtnCallBack: () {
                                isEdit = !isEdit;
                                setState(() {});
                              },
                              title: "",
                              isNotification: true,
                              isEditBtn: isAuth,
                              isAddTrackBtn: false,
                            ),
                          ),

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 1.h,
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      memberModel.memberNickName ?? "",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),

                                    if (isEdit) ...[
                                      SizedBox(
                                        width: 3,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          print('닉네임 수정');

                                          await AppBottomModalRouter().fnModalRouter(
                                              context,
                                              1,
                                              maxLines: 1,
                                              infoText: memberModel.memberNickName!,
                                              callBack: (String newTitle) async {
                                                setNewTitle(1, newTitle);
                                              });

                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/edit.svg',
                                          width: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ]

                                  ],
                                                            ),
                                  Text(
                                    'following ${memberModel.memberFollowCnt ?? '0'}  follower ${memberModel.memberFollowerCnt ?? '0'}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),)
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            SizedBox(height: 5,),
                            ///자기 소개
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      memberModel.memberInfo ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ),
                                if (isEdit) ...[
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () async {
                                      print('자기소개 수정');
                                      await AppBottomModalRouter().fnModalRouter(
                                        context,
                                        1,
                                        maxLines: null,
                                        infoText: memberModel.memberInfo ?? "",
                                        callBack: (String newTitle) async {
                                          setNewTitle(2, newTitle);
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

                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Popular tracks',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            if (trackProv.memberPopularTrackList.length == 0)
                              EmptyMessageItem(paddingHeight: 0,),

                            FutureBuilder<bool>(
                              future: _getUserTrackFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CustomProgressIndicatorItem());
                                } else {

                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [

                                        Wrap(
                                          spacing: 5.0, // 아이템 간의 가로 간격
                                          runSpacing: 20.0, // 줄 간격
                                          alignment: WrapAlignment.spaceBetween,
                                          children: trackProv.memberPopularTrackList.asMap().entries.map((entry) {
                                            int i = entry.key;
                                            Track trackItem = entry.value;
                                            return Row(
                                              children: [
                                                TrackSquareItem(
                                                  trackItem: trackItem,
                                                  trackItemIdx : i ,
                                                  appScreenName: "memberPopularTrackList",
                                                  initAudioPlayerTrackListCallBack: () {

                                                    List<int> trackIdList = trackProv.memberPopularTrackList.map((item) => int.parse(item.trackId.toString())).toList();

                                                    trackProv.audioPlayerTrackList = List.from(trackProv.memberPopularTrackList);
                                                    trackProv.setAudioPlayerTrackIdList(trackIdList);
                                                    trackProv.notify();

                                                  },
                                                ),

                                                SizedBox(width: 3,),
                                              ],
                                            );
                                          },
                                          ).toList(),
                                        ),

                                      ],
                                    ),
                                  );
                                }
                              }
                            ),

                            SizedBox(
                              height: 20,
                            ),

                            FutureBuilder<bool>(
                                future: _getUserPlayListFuture,
                                builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CustomProgressIndicatorItem());
                                } else {

                                  PlaylistList playListList = playListProv.playlists;
                                  List<PlayListInfoModel> memberPlayList = playListProv.playlists.playList;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                                Text(
                                                  'Playlists',
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.w600),
                                                ),

                                              if (isAuth)...[
                                                SizedBox(width: 3,),

                                                GestureDetector(
                                                  onTap: () async {
                                                    await AppBottomModalRouter().fnModalRouter(context, 2);
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ]

                                            ],
                                          ),

                                          if (playListList.memberPagePlayListTotalCount! > 6)
                                            GestureDetector(
                                              onTap: () {
                                                GoRouter.of(context).push('/memberPlayList/${memberModel.memberId}');
                                              },
                                              child: Text(
                                                'more',
                                                style: GoogleFonts.roboto(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),

                                      if (memberPlayList.length == 0)
                                        EmptyMessageItem(paddingHeight: 0),

                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            for (int i = 0; i < memberPlayList.length; i++)...[
                                              PlaylistItem(playList: memberPlayList[i],isAlbum: false),
                                              SizedBox(width: 5),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FutureBuilder<bool>(
                                future: _getUserAlbumFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CustomProgressIndicatorItem());
                                  } else {

                                    PlaylistList playListList = playListProv.albums;
                                    List<PlayListInfoModel> memberPlayList = playListProv.albums.playList;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                  Text(
                                                    'Albums',
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.white,
                                                        fontSize: 19,
                                                        fontWeight: FontWeight.w600),
                                                  ),

                                                if (isAuth)...[
                                                  SizedBox(width: 3,),

                                                  GestureDetector(
                                                    onTap : () async {
                                                      await AppBottomModalRouter().fnModalRouter(
                                                            context,
                                                            5,
                                                            isAlbum: true,
                                                            callBack: () async {
                                                              GoRouter.of(context).pop();
                                                              await GoRouter.of(context).push('/memberPage/${loginMemberId}');
                                                            }
                                                          );

                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ]

                                              ],
                                            ),
                                            if (playListList.memberPageAlbumTotalCount! > 6)
                                              GestureDetector(
                                                onTap: () {
                                                  GoRouter.of(context).push('/memberAlbums/${memberModel.memberId}');
                                                },
                                                child: Text(
                                                  'more',
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        if (memberPlayList.length == 0)
                                          EmptyMessageItem(paddingHeight: 0),

                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              for (int i = 0; i < memberPlayList.length; i++)...[
                                                PlaylistItem(
                                                    playList: memberPlayList[i],
                                                    isAlbum: true
                                                ),
                                                SizedBox(width: 5),
                                              ]

                                            ],
                                          ),
                                        ),

                                      ],
                                    );
                                  }
                                }
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Tracks',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            FutureBuilder<bool>(
                              future: _getUserTrackFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CustomProgressIndicatorItem());
                                } else {

                                  return Column(
                                    children: [

                                      if (trackProv.memberTrackList.length == 0)
                                        EmptyMessageItem(paddingHeight: 0),

                                      for (int i = 0; i < trackProv.memberTrackList.length; i++) ...[
                                        Container(
                                            padding: EdgeInsets.only(bottom: 10),
                                            child: TrackItem(
                                              appScreenName: "MemberPageScreen",
                                              trackItem: trackProv.memberTrackList[i],
                                              trackItemIdx : i,
                                              isAudioPlayer: false,
                                              initAudioPlayerTrackListCallBack: () async {

                                                await trackProv.getMemberPageAllTrack(widget.memberId,comnLoadProv.listDataOffset, trackProv.trackListModel.allTrackTotalCount!);

                                                List<int> trackIdList = trackProv.memberTrackList.map((item) => int.parse(item.trackId.toString())).toList();

                                                trackProv.audioPlayerTrackList = List.from(trackProv.memberTrackList);
                                                trackProv.setAudioPlayerTrackIdList(trackIdList);
                                                trackProv.notify();
                                            },),
                                        ),
                                      ],
                                      CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall),
                                    ],
                                  );
                                }
                              }
                            ),



                          ],
                        ),
                      )

                    ],
                  ),
                ),

              );


            }
          },
        ),
      ),
    );
  }
}
