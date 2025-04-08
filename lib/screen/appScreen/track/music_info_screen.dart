import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/comn/upload.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';

import 'package:skrrskrr/screen/modal/comment/comment.dart';
import 'package:skrrskrr/screen/modal/track/track_info_edit.dart';
import 'package:skrrskrr/screen/subScreen/track/track_comment_btn.dart';
import 'package:skrrskrr/screen/subScreen/track/track_like_btn.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';

import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class MusicInfoScreen extends StatefulWidget {
  const MusicInfoScreen({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<MusicInfoScreen> createState() => _MusicInfoScreenState();
}

class _MusicInfoScreenState extends State<MusicInfoScreen> {
  late String? loginMemberId;
  bool isAuth = false;
  bool isEdit = false;
  bool moreInfo = false;
  Uint8List? _imageBytes = null; // 선택된 이미지의 바이트 데이터

  late TrackProv trackProv;
  late AppProv appProv;
  late PlayerProv playerProv;
  late Future<bool> _getTrackInfoFuture;
  late Future<bool> _getRecommendTrackFuture;

  @override
  void initState() {
    print("MusicInfoScreen initstate");
    super.initState();
    _getTrackInfoFuture = Provider.of<TrackProv>(context, listen: false).getTrackInfo(widget.track.trackId);
    _getRecommendTrackFuture = Provider.of<TrackProv>(context, listen: false).getRecommendTrackList(widget.track.trackId,widget.track.trackCategoryId!);
    _loadMemberId();
  }

  void _loadMemberId() async {
    loginMemberId = await Helpers.getMemberId();
  }


  @override
  Widget build(BuildContext context) {

    trackProv = Provider.of<TrackProv>(context);
    appProv = Provider.of<AppProv>(context,listen: false);
    playerProv = Provider.of<PlayerProv>(context,listen: false);

    ImageProv imageProv = Provider.of<ImageProv>(context);
    FollowProv followProv = Provider.of<FollowProv>(context);


    Future<void> _pickImage(Track trackInfoModel) async {
      Upload upload = Upload();
      upload.trackId = widget.track.trackId;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // 이미지 파일만 선택
      );

      if (result != null && result.files.isNotEmpty) {
        _imageBytes = await Helpers.cropImage(result.files.first.path!);

        FilePickerResult filePickerResult =
            await Helpers.convertUint8ListToFilePickerResult(
                _imageBytes!, result.files.first.size);

        upload.uploadImage = filePickerResult;
        upload.uploadImageNm = result.files.first.name ?? "";

        String newImagePath = await imageProv.updateTrackImage(upload);

        if(newImagePath != ""){
          widget.track.trackImagePath = newImagePath;
        }
        setState(() {});
      }
    }



    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff000000),
          width: 100.w,
          height: 150.h,
          child: FutureBuilder<bool>(
            future: _getTrackInfoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('데이터가 없습니다.'));
              }

              widget.track.updateApiData(trackProv.trackInfoModel);
              trackProv.trackInfoModel = widget.track;
              isAuth = Helpers.getIsAuth(widget.track.memberId.toString(), loginMemberId!);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 140.h,
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isAuth) {
                                      _pickImage(widget.track);
                                    }
                                  },
                                  child: CustomCachedNetworkImage(
                                      imagePath: widget.track.trackImagePath,
                                      imageWidth : 100.w,
                                      imageHeight : 50.h
                                  ),

                                ),
                                Container(
                                  width: 100.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        // 하단은 어두운 색
                                        Colors.transparent,
                                        // 상단은 투명
                                      ],
                                      stops: [0.1, 1.0],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if(isEdit)...[
                                        GestureDetector(
                                          onTap:() => {
                                            _pickImage(widget.track)
                                          },
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
                                right : 0,
                                child: CustomAppbar(
                                    fnBackBtncallBack: ()=>{GoRouter.of(context).pop()},
                                    fnUpdtBtncallBack:()=>{
                                      setState(() {
                                        isEdit = !isEdit;
                                      }),
                                    },

                                    title: "",
                                    isNotification: true,
                                   isEditBtn: isAuth,
                                  isAddPlayListBtn : false,
                                  isAddTrackBtn : false,
                                  isAddAlbumBtn : false,
                                )
                            ),

                            Positioned(
                              top: 41.h,
                              left: 10,
                              right: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            SizedBox(
                                              width: 80.w,
                                              child: Text(
                                                widget.track.trackNm ?? "null",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.w800),
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                            ),

                                            Row(
                                              children: [
                                                Text(
                                                  widget.track.memberNickName ??
                                                      "null",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/play.svg',
                                                  color: Colors.grey,
                                                  width: 10,
                                                  height: 10,
                                                ),
                                                Text(
                                                  ' ${widget.track.trackPlayCnt} plays ',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              widget.track.trackCategoryId == null
                                                  ? "null"
                                                  : Helpers.getCategory(
                                                  widget.track.trackCategoryId!),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              widget.track.trackTime ?? "null",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              widget.track.trackUploadDate ??
                                                  "null",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                          ],
                                        ),

                                        GestureDetector(
                                          onTap: () async {
                                            await trackProv.setLastListenTrackId(widget.track.trackId!);
                                            await playerProv.audioPause();
                                            appProv.reload();
                                          },
                                          child: Container(
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
                                        )
                                      ],
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          TrackLikeBtn(track: widget.track),
                                          SizedBox(width: 10,),
                                          TrackCommentBtn( track : widget.track),
                                        ],
                                      ),
                                      if(isEdit)...[
                                        SizedBox(
                                          width: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print('음원 소개 편집 버튼');

                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return Dialog(
                                                  backgroundColor:
                                                  Colors.transparent,
                                                  child: TrackInfoEdit(
                                                    trackInfo:
                                                    widget.track.trackInfo!,
                                                    onSave: (String? trackInfo) async {
                                                      widget.track.trackInfo = trackInfo;

                                                      bool isUpdate = await trackProv.setTrackInfo(trackInfo);
                                                      if(isUpdate) {
                                                        Fluttertoast.showToast(msg: '변경되었습니다.');
                                                        setState(() {});
                                                      } else {
                                                        Fluttertoast.showToast(msg: '잠시 후 다시 시도해주세요');
                                                      }
                                                      ///  저장할떄 리빌드되면서 기본값으로 덮어씌우는 듯
                                                      ///  영역 나누고나서 다시 테스트 필요 우선 trackinfo 넘겨서 저장
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
                                  SizedBox(
                                    height: 15,
                                  ),

                                  /// 곡 정보
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      children: [
                                        Container(
                                          constraints: moreInfo
                                              ? BoxConstraints()
                                              : BoxConstraints(
                                                  maxHeight: 10.h),
                                          width: 90.w,
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            widget.track.trackInfo ?? "정보 없음",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              moreInfo = !moreInfo;
                                            });
                                          },
                                          child: Text(
                                            !moreInfo ? '더 보기' : '접기',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          GoRouter.of(context).push('/userPage/${widget.track.memberId}');
                                        },
                                        child: Column(
                                          children: [
                                            ClipOval(
                                              child: Image.asset(
                                                'assets/images/testImage.png',
                                                width: 110,
                                                height: 110,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              widget.track.memberNickName ??
                                                  "null",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      if (!isEdit)
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                widget.track.followMember ==
                                                        true
                                                    ? WidgetStateProperty.all(
                                                        Colors.white)
                                                    : WidgetStateProperty.all(
                                                        Colors.white),
                                          ),
                                          onPressed: () async {
                                            print('버튼 클릭');

                                            await followProv.setFollow(
                                                widget.track.memberId,
                                                loginMemberId);

                                            setState(() {});
                                          },
                                          child: Text(
                                            widget.track.followMember == true
                                                ? '언팔로우'
                                                : '팔로우',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Recommended Track',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 10),


                                  FutureBuilder<bool>(
                                      future: _getRecommendTrackFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(child: Text('오류 발생: ${snapshot.error}'));
                                        } else if (!snapshot.hasData) {
                                          return Center(child: Text('데이터가 없습니다.'));
                                        }
                                        return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  for(int i = 0; i< widget.track.recommendTrackList.length; i++)...[
                                                    TrackSquareItem(
                                                      track: widget.track.recommendTrackList[i],
                                                      bgColor: Colors.lightBlueAccent,
                                                    ),
                                                    SizedBox(width: 15,),

                                                  ]

                                                ],
                                              )
                                          );
                                   }
                                 ),

                                  SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
