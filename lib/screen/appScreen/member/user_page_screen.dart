import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/comn/upload.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';

import 'package:skrrskrr/screen/modal/track/title_info_edit.dart';
import 'package:skrrskrr/screen/appScreen/playlist/play_list_screen.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_lists_list_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_horizontal_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class UserPageScreen extends StatefulWidget {
  const UserPageScreen({
    super.key,
    required this.memberId,
  });

  final int memberId;

  @override
  State<UserPageScreen> createState() => _UserPageScreenState();
}

class _UserPageScreenState extends State<UserPageScreen> {
  bool isAuth = false;
  bool isEdit = false;
  late MemberProv memberProv;
  late TrackProv trackProv;
  late ImageProv imageProv;

  Uint8List? _imageBytes = null; // 선택된 이미지의 바이트 데이터
  late String? loginMemberId;
  late Future<bool> _getUserInitFuture;
  late Future<bool> _getUserTrackFuture;
  late Future<bool> _getUserPlayListFuture;
  late Future<bool> _getUserAlbumFuture;
  late Future<bool> _getUserPopularTrackFuture;
  late ComnLoadProv comnLoadProv;
  late PlayListProv playListProv;

  List<Track> popularTrackList = [];
  List<Track> allTrackList = [];

  @override
  void initState() {
    print("UserPageScreen initstate");
    super.initState();
    _getUserInitFuture = Provider.of<MemberProv>(context, listen: false).getMemberPageInfo(widget.memberId);
    _getUserTrackFuture = Provider.of<TrackProv>(context, listen: false).getMemberPageTrack(widget.memberId, 0);
    _getUserPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getMemberPagePlayList(widget.memberId,0,7);
    _getUserAlbumFuture = Provider.of<PlayListProv>(context, listen: false).getMemberPageAlbum(widget.memberId,0,7);
    _getUserPopularTrackFuture = Provider.of<TrackProv>(context, listen: false).getMemberPagePopularTrack(widget.memberId);
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
    memberProv = Provider.of<MemberProv>(context);
    playListProv = Provider.of<PlayListProv>(context);
    trackProv = Provider.of<TrackProv>(context);
    imageProv = Provider.of<ImageProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);


    Future<void> _pickImage(MemberModel memberModel) async {
      Upload upload = Upload();
      upload.memberId = memberModel.memberId;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // 이미지 파일만 선택
      );

      if (result != null && result.files.isNotEmpty) {
        _imageBytes = await Helpers.cropImage(result.files.first.path!);

        FilePickerResult filePickerResult = await Helpers.convertUint8ListToFilePickerResult(
            _imageBytes!, result.files.first.size);

        upload.uploadImage = filePickerResult;
        upload.uploadImageNm = result.files.first.name ?? "";

        String newImagePath = await imageProv.updateMemberImage(upload);
        if (newImagePath.isNotEmpty) {
          memberModel.memberImagePath = newImagePath;
        }
        setState(() {});
      }
    }

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
          gradient: LinearGradient(
            colors: [
              Color(0xff000000), // 상단의 연한 색
              Color(0xff000000), // 하단의 어두운 색
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<bool>(
          future: _getUserInitFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {

              MemberModel memberModel = memberProv.model;
              isAuth = Helpers.getIsAuth(memberModel.memberId.toString(), loginMemberId!);

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (trackProv.trackModel.allTrackTotalCount! > allTrackList.length) {
                    if (comnLoadProv.shouldLoadMoreData(notification)) {
                      comnLoadProv.loadMoreData(trackProv, 'MemberPageTrack', allTrackList.length, memberId: widget.memberId);
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
                                height: 58.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter, // 하단부터
                                    end: Alignment.topCenter, // 상단까지
                                    colors: [
                                      Colors.black.withOpacity(1), // 하단은 어두운 색
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
                                        onTap: () => {_pickImage(memberModel)},
                                        child: Text(
                                          '이미지 변경',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),



                            ],
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: CustomAppbar(
                              fnBackBtncallBack: () => {
                                GoRouter.of(context).pop()
                              },
                              fnUpdtBtncallBack: () {
                                isEdit = !isEdit;
                                setState(() {});
                              },
                              title: "",
                              isNotification: true,
                              isEditBtn: isAuth,
                              isAddPlayListBtn: false,
                              isAddTrackBtn: false,
                              isAddAlbumBtn: false,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 44.h,
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

                                            showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  return Dialog(
                                                    backgroundColor: Colors.transparent,
                                                    child: TitleInfoEditModal(
                                                        title: memberModel.memberNickName!,
                                                        fnCallBack: (String? newTitle) {
                                                          setNewTitle(1, newTitle!);
                                                        }),
                                                  );
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
                                    '팔로우 ${memberModel.memberFollowCnt ?? '0'}  팔로워 ${memberModel.memberFollowerCnt ?? '0'}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),

                                  ///자기 소개
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 75.w,
                                                  child: Text(
                                                    memberModel.memberInfo ?? "",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                if (isEdit) ...[
                                                  GestureDetector(
                                                    onTap: () async {
                                                      print('자기소개  수정');

                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible: true,
                                                          builder: (context) {
                                                            return Dialog(
                                                              backgroundColor:
                                                              Colors.transparent,
                                                              child:
                                                              TitleInfoEditModal(
                                                                  title: memberModel
                                                                      .memberInfo ??
                                                                      "",
                                                                  fnCallBack:
                                                                      (String?
                                                                  newTitle) {
                                                                    setNewTitle(2,
                                                                        newTitle!);
                                                                  }),
                                                            );
                                                          });
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/images/edit.svg',
                                                      width: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
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

                              FutureBuilder<bool>(
                              future: _getUserPopularTrackFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {

                                  popularTrackList = trackProv.trackListFilter("MemberPagePopularTrackList");
                                  return Column(
                                    children: [
                                      TrackScrollHorizontalItem(trackList: popularTrackList)
                                    ]
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
                                  return CircularProgressIndicator();
                                } else {

                                  PlaylistList playListList = playListProv.playlists;
                                  List<PlayListInfoModel> memberPlayList = playListProv.playlists.playList;

                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Playlists',
                                            style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          if (playListList.memberPagePlayListTotalCount != 6)
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

                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for(int i = 0; i < memberPlayList.length; i++)
                                              PlayListsListItem(playList: memberPlayList[i],isAlbum: false),
                                            SizedBox(width: 20),
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
                                    return CircularProgressIndicator();
                                  } else {

                                    PlaylistList playListList = playListProv.albums;
                                    List<PlayListInfoModel> memberPlayList = playListProv.albums.playList;

                                    return Column(
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
                                            if (playListList.memberPagePlayListTotalCount != 6)
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

                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for(int i = 0; i < memberPlayList.length; i++)
                                                PlayListsListItem(
                                                    playList: memberPlayList[i],
                                                    isAlbum: true
                                                ),
                                              SizedBox(width: 20),
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {

                                  Set<Track> allTrackSet = allTrackList.toSet(); // 중복 제거용 Set 생성
                                  List<Track> list = trackProv.trackModel.trackList;

                                  trackProv.addUniqueTracksToList(
                                    sourceList: list,
                                    targetSet: allTrackSet,
                                    targetList: allTrackList,
                                    trackCd: "MemberPageTrackList",
                                  );

                                  return Column(
                                    children: [
                                      for (int i = 0; i < allTrackList.length; i++) ...[
                                        Container(padding: EdgeInsets.only(bottom: 10),
                                            child: TrackListItem(
                                              trackItem: allTrackList[i],
                                              isAudioPlayer: false,
                                              callBack: (){

                                            },)
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
