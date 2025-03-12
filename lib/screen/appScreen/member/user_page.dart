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
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';

import 'package:skrrskrr/screen/modal/track/title_info_edit.dart';
import 'package:skrrskrr/screen/appScreen/playlist/play_list.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
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

  Uint8List? _imageBytes = null; // 선택된 이미지의 바이트 데이터
  late String? memberId;
  late Future<bool> _getUserInitFuture;

  @override
  void initState() {
    super.initState();
    _getUserInitFuture = Provider.of<MemberProv>(context, listen: false).getMemberPageInfo(widget.memberId);
    _loadMemberId();
  }

  void _loadMemberId() async {
    memberId = await Helpers.getMemberId();
  }

  bool getIsAuth(checkMemberId)  {
    return checkMemberId == memberId;
  }

  @override
  Widget build(BuildContext context) {

    MemberProv memberProv = Provider.of<MemberProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);

    Future<void> _pickImage(MemberModel memberModel) async {
      Upload upload = Upload();
      upload.memberId = memberModel.memberId;

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

        String newImagePath = await imageProv.updateMemberImage(upload);
        if(newImagePath.isNotEmpty){
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
      body: SingleChildScrollView(
        child: Container(
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
          width: 100.w,
          height: 195.h,
          child: FutureBuilder<bool>(
            future: _getUserInitFuture,
            // 비동기 함수 호출
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                MemberModel memberModel = memberProv.model;

                isAuth = getIsAuth(memberModel.memberId.toString());

                return Stack(
                  children: [
                    Stack(
                      children: [
                        CustomCachedNetworkImage(
                            imagePath: memberModel.memberImagePath,
                            imageWidth : 100.w,
                            imageHeight : 50.h
                        ),

                        Container(
                          width: 100.w,
                          height: 50.h,
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
                              if(isEdit)...[
                                GestureDetector(
                                  onTap:() => {
                                     _pickImage(memberModel)
                                  },
                                  child: Text(
                                    '이미지 변경',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: CustomAppbar(
                        fnBackBtncallBack: () => {Navigator.pop(context)},
                        fnUpdtBtncallBack: () => {
                          setState(() {
                            isEdit = !isEdit;
                          })
                        },

                        title: "",
                        isNotification: true,
                        isEditBtn: isAuth,
                        isAddPlayListBtn : false,
                        isAddTrackBtn : false,
                        isAddAlbumBtn : false,
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: TitleInfoEditModal(
                                                  title: memberModel
                                                      .memberNickName!,
                                                  fncallBack:
                                                      (String? newTitle) {
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                fncallBack:
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

                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '인기 있는 트랙',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: List.generate(
                                        memberModel.popularTrackList!.length,
                                        (i) {
                                      return GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: TrackListItem(
                                              trackItem: memberModel
                                                  .popularTrackList![i],),
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '앨범',
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (int i = 0;
                                            i < memberModel.playListDTO!.length;
                                            i++) ...[
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: GestureDetector(
                                              onTap: () {
                                                GoRouter.of(context).push('/playList/${memberModel.playListDTO![i].playListId}');
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      ClipRRect(
                                                        child:
                                                        CustomCachedNetworkImage(
                                                            imagePath: memberModel.playListDTO![i].playListImagePath,
                                                            imageWidth : 40.w,
                                                            imageHeight : 20.h
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 40.w,
                                                        height: 20.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .bottomCenter,
                                                            end: Alignment
                                                                .topCenter,
                                                            colors: [
                                                              Colors.black
                                                                  .withOpacity(
                                                                      0.9),
                                                              // 하단은 어두운 색
                                                              Colors
                                                                  .transparent,
                                                              // 상단은 투명
                                                            ],
                                                            stops: [0, 1.0],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 10,
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 10,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                          child: CustomCachedNetworkImage(
                                                              imagePath: memberModel.playListDTO![i].playListImagePath,
                                                              imageWidth : 20.w,
                                                              imageHeight : 10.h
                                                          ),

                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    width: 160,
                                                    child: Text(
                                                      memberModel
                                                          .playListDTO![i]
                                                          .playListNm!,
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    memberModel.playListDTO![i]
                                                        .memberNickName!,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 20), // 간격 추가
                                        ],
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '전체 트랙',
                                        style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'more',
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  for (int i = 0;
                                      i < memberModel.allTrackList!.length;
                                      i++) ...[
                                    Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: TrackListItem(
                                          trackItem:
                                              memberModel.allTrackList![i],


                                        ))
                                  ],
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
