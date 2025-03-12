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
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';

import 'package:skrrskrr/screen/modal/comment/comment.dart';
import 'package:skrrskrr/screen/modal/track/track_info_edit.dart';
import 'package:skrrskrr/screen/modal/track/track_like_btn.dart';

import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/track/track_scroll_horizontal_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class MusicInfoScreen extends StatefulWidget {
  const MusicInfoScreen({
    super.key,
    
    required this.trackId,
    
  });

  
  final int? trackId;


  @override
  State<MusicInfoScreen> createState() => _MusicInfoScreenState();
}

class _MusicInfoScreenState extends State<MusicInfoScreen> {
  bool moreInfo = false;
  late String? memberId;
  bool isAuth = false;
  bool isEdit = false;
  Uint8List? _imageBytes = null; // 선택된 이미지의 바이트 데이터

  late Future<bool> _getTrackInfoFuture;


  @override
  void initState() {
    super.initState();
    _getTrackInfoFuture = Provider.of<TrackProv>(context, listen: false).getTrackInfo(widget.trackId);
    _loadMemberId();
  }

  void _loadMemberId() async {
    memberId = await Helpers.getMemberId();
  }


  @override
  Widget build(BuildContext context) {

    TrackProv trackProv = Provider.of<TrackProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);

    FollowProv followProv = Provider.of<FollowProv>(context);

    Future<void> _pickImage(Track trackInfoModel) async {
      Upload upload = Upload();
      upload.trackId = trackInfoModel.trackId;

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
          trackInfoModel.trackImagePath = newImagePath;
        }
        setState(() {});
      }
    }



    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xff000000),
          width: 100.w,
          height: 140.h,
          child: FutureBuilder<bool>(
            future: _getTrackInfoFuture,
            // 비동기 메소드 호출
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('데이터가 없습니다.'));
              }


              Track trackInfoModel = trackProv.trackInfoModel;


              if (trackInfoModel.memberId.toString() == memberId.toString()) {
                isAuth = true;
              }

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
                                      _pickImage(trackInfoModel);
                                    }
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: imageProv.imageLoader(
                                        trackInfoModel.trackImagePath),
                                    // 이미지 URL
                                    placeholder: (context, url) {
                                      return CircularProgressIndicator(); // 로딩 중에 표시할 위젯
                                    },
                                    errorWidget: (context, url, error) {
                                      print('이미지 로딩 실패: $error');
                                      return Icon(Icons.error); // 로딩 실패 시 표시할 위젯
                                    },
                                    fadeInDuration: Duration(milliseconds: 500),
                                    // 이미지가 로드될 때 페이드 인 효과
                                    fadeOutDuration: Duration(milliseconds: 500),
                                    // 이미지가 사라질 때 페이드 아웃 효과
                                    width: 100.w,
                                    height: 50.h,
                                    // 이미지의 세로 크기
                                    imageBuilder: (context, imageProvider) {
                                      return Image(
                                          image: imageProvider); // 이미지가 로드되면 표시
                                    },
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
                                            _pickImage(trackInfoModel)
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
                                    fnBackBtncallBack: ()=>{Navigator.pop(context)},
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
                                            Text(
                                              trackInfoModel.trackNm ?? "null",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  trackInfoModel.memberNickName ??
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
                                                  ' ${trackInfoModel.trackPlayCnt} plays ',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              trackInfoModel.trackCategoryId ==
                                                      null
                                                  ? " null"
                                                  : Helpers.getCategory(
                                                      trackInfoModel
                                                          .trackCategoryId!),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              trackInfoModel.trackTime ?? "null",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              trackInfoModel.trackUploadDate ??
                                                  "null",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 25,
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
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          TrackLikeBtn(
                                              trackInfoModel: trackInfoModel),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              AppBottomModalRouter.fnModalRouter(context,0,
                                                  trackId: widget.trackId);
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/message.svg',
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  trackInfoModel.commentsCnt
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15),
                                                ),
                                              ],
                                            ),
                                          ),
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
                                                    trackInfoModel.trackInfo!,
                                                    onSave: (String? trackInfo) async {
                                                      trackInfoModel.trackInfo = trackInfo;

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
                                            trackInfoModel.trackInfo ?? "정보 없음",
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
                                          GoRouter.of(context).push('/userPage/${trackInfoModel.memberId}');
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
                                              trackInfoModel.memberNickName ??
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
                                                trackInfoModel.followMember ==
                                                        true
                                                    ? WidgetStateProperty.all(
                                                        Colors.white)
                                                    : WidgetStateProperty.all(
                                                        Colors.white),
                                          ),
                                          onPressed: () async {
                                            print('버튼 클릭');

                                            await followProv.setFollow(
                                                trackInfoModel.memberId,
                                                memberId);

                                            setState(() {});
                                          },
                                          child: Text(
                                            trackInfoModel.followMember == true
                                                ? '언팔로우'
                                                : '팔로우',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '추천',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 10),

                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          for(int i = 0; i< trackInfoModel.recommendTrackList.length; i++)...[
                                            TrackSquareItem(
                                              track: trackInfoModel.recommendTrackList[i],

                                              bgColor: Colors.lightBlueAccent,
                                            ),
                                            SizedBox(width: 15,),

                                          ]

                                        ],
                                      )
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
