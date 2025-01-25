import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';

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
    ImageProv imageProv = Provider.of<ImageProv>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < widget.memberList.length; i++) ...[
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 2),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      print('이동');
                      GoRouter.of(context).push('/musicInfo/${widget.memberList[i].memberId}');
                    },
                    child: CachedNetworkImage(
                      imageUrl: imageProv.imageLoader(widget.memberList![i].memberImagePath),  // 이미지 URL
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
                      height: 10.h,  // 이미지의 세로 크기
                      fit: BoxFit.cover,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
                      imageBuilder: (context, imageProvider) {

                        return Image(image: imageProvider);  // 이미지가 로드되면 표시
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: [
                      Text(
                        widget.memberList[i].memberNickName,
                        style: TextStyle(color: Colors.white),
                      ),
                      if (widget.memberList![i].isFollowedCd == 2 ||
                          widget.memberList![i].isFollowedCd == 3)
                        Text(
                          widget.memberList![i].isFollowedCd == 2
                              ? '나를 팔로우합니다'
                              : widget.memberList![i].isFollowedCd == 3
                                  ? '나를 팔로우합니다'
                                  : '',
                          style: TextStyle(color: Colors.white),
                        ),
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
