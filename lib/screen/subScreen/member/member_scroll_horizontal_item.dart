import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';

import 'package:skrrskrr/utils/helpers.dart';

class MemberScrollHorizontalItem extends StatefulWidget {
  const MemberScrollHorizontalItem({
    super.key,
    required this.memberList,
    
  });

  final dynamic memberList;


  @override
  State<MemberScrollHorizontalItem> createState() =>
      _MemberScrollHorizontalItemState();
}

class _MemberScrollHorizontalItemState
    extends State<MemberScrollHorizontalItem> {

  bool isImageLoad = false;

  @override
  Widget build(BuildContext context) {
    FollowProv followProv = Provider.of<FollowProv>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < widget.memberList.length; i++) ...[
            Container(
              padding: EdgeInsets.all(5),
           
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print('이동');
                      GoRouter.of(context).push('/memberPage/${widget.memberList[i].memberId}');
                    },
                    child: ClipOval(
                      child: CustomCachedNetworkImage(
                          imagePath:widget.memberList![i].memberImagePath,
                          imageWidth : 25.w,
                          imageHeight : 12.5.h,
                        isBoxFit: true,
                      ),
                    ),

                  ),
                  SizedBox(height: 8),
                  Column(
                    children: [
                      Text(
                        widget.memberList[i].memberNickName,
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      // if (widget.memberList![i].isFollowedCd == 2 ||
                      //     widget.memberList![i].isFollowedCd == 3)
                      //   Text(
                      //     widget.memberList![i].isFollowedCd == 2
                      //         ? '나를 팔로우합니다'
                      //         : widget.memberList![i].isFollowedCd == 3
                      //             ? '나를 팔로우합니다'
                      //             : '',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xFF1C1C1C)),
                        // 버튼 배경을 투명으로 설정
                        shadowColor: WidgetStateProperty.all(Colors.transparent),
                        // 그림자 제거
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
                        )),
                      ),
                      onPressed: () async {

                        int followingMemberId = int.parse(await Helpers.getMemberId());

                        await followProv.setFollow(widget.memberList![i].memberId,followingMemberId);

                        setState(() {
                          if(widget.memberList![i].isFollowedCd == 0) {
                            widget.memberList![i].isFollowedCd = 1;
                          } else if(widget.memberList![i].isFollowedCd == 1) {
                            widget.memberList![i].isFollowedCd = 0;
                          } else if(widget.memberList![i].isFollowedCd == 2) {
                            widget.memberList![i].isFollowedCd = 3;
                          } else if (widget.memberList![i].isFollowedCd == 3){
                            widget.memberList![i].isFollowedCd = 2;
                          }
                        });
                      },
                      child: Text(
                        widget.memberList![i].isFollowedCd == 1
                            ? "언팔로우"
                            : widget.memberList![i].isFollowedCd == 3
                                ? '언팔로우'
                                : widget.memberList![i].isFollowedCd == 2
                                    ? '팔로우'
                                    : '팔로우',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 20),
          ],
        ],
      ),
    );
  }
}
