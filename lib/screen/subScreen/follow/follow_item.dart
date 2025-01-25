import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/follow/follow_model.dart';
import 'package:skrrskrr/prov/image_prov.dart';

import 'package:skrrskrr/utils/helpers.dart';


class FollowItem extends StatefulWidget {
  const FollowItem({
    super.key,
    
    required this.filteredFollowItem,
    required this.setFollow,
    required this.isFollowingItem,
    required this.isSearch,
  });


  final FollowInfoModel? filteredFollowItem;
  final Function setFollow;
  final bool isFollowingItem;
  final bool isSearch;

  @override
  State<FollowItem> createState() => _FollowItemState();
}

class _FollowItemState extends State<FollowItem> {

  bool isImageLoad = false;


  @override
  Widget build(BuildContext context) {

    ImageProv imageProv = Provider.of<ImageProv>(context);

    return Container(
      padding: EdgeInsets.only(top : 5, bottom : 5,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              GoRouter.of(context).push('/userPage/${widget.filteredFollowItem?.followMemberId}');
            },
            child: Row(
              children: [

                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageProv.imageLoader(widget.filteredFollowItem!.followImagePath),  // 이미지 URL
                    placeholder: (context, url) {
                      
                      return CircularProgressIndicator();  // 로딩 중에 표시할 위젯
                    },
                    errorWidget: (context, url, error) {
                      print('이미지 로딩 실패: $error');
                      return Icon(Icons.error);  // 로딩 실패 시 표시할 위젯
                    },
                    fadeInDuration: Duration(milliseconds: 500),  // 이미지가 로드될 때 페이드 인 효과
                    fadeOutDuration: Duration(milliseconds: 500),  // 이미지가 사라질 때 페이드 아웃 효과
                    width: 13.w,  // 이미지의 세로 크기
                  
                    fit: BoxFit.cover,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
                    imageBuilder: (context, imageProvider) {
                      
                      return Image(image: imageProvider);  // 이미지가 로드되면 표시
                    },
                  ),
                ),


                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.filteredFollowItem!.followNickName!,
                      style: TextStyle(color: Colors.white),
                    ),
                    if (!widget.isSearch && widget.filteredFollowItem!.isFollowedCd != 0)
                      Text(
                         widget.isFollowingItem
                             ? widget.filteredFollowItem!.isFollowedCd != 3 ? '' : '나를 팔로우합2니다'
                             : widget.filteredFollowItem!.isFollowedCd == 3 ?  '내가 팔로우합니다.' : '',
                        style:
                        TextStyle(color: Colors.grey, fontSize: 13),
                      ),

                    if (widget.isSearch && widget.filteredFollowItem!.isFollowedCd != 0)
                      Text(
                        widget.filteredFollowItem!.isFollowedCd == 3 || widget.filteredFollowItem!.isFollowedCd == 2
                            ? '나를 팔로우 합니다'
                            : '',
                        style:
                        TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if(widget.isSearch || widget.isFollowingItem ||  widget.filteredFollowItem!.isFollowedCd == 2)
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),  // 모서리 둥글지 않게 설정 (네모 형태)
                ),
              ),
              backgroundColor: WidgetStateProperty.all(
                  widget.filteredFollowItem!.isFollowedCd == 0
                      ? widget.filteredFollowItem!.isFollow! ? Color(0xff1c1c1c) : Color(0xff1c1c1c)
                      : widget.filteredFollowItem!.isFollowedCd == 1
                      ? widget.filteredFollowItem!.isFollow! ? Color(0xff1c1c1c) : Color(0xff1c1c1c)
                      : widget.filteredFollowItem!.isFollowedCd == 3
                      ? widget.filteredFollowItem!.isFollow! ? Color(0xff1c1c1c) : Color(0xff1c1c1c)
                      : widget.filteredFollowItem!.isFollowedCd == 2
                      ? widget.filteredFollowItem!.isFollow! ? Color(0xff1c1c1c) : Color(0xff1c1c1c) : Color(0xff1c1c1c),
              ),

              side: WidgetStateProperty.all(
                BorderSide(
                  color:  widget.filteredFollowItem!.isFollow!
                      ? Color(0xff000000)
                      : Color(0xff000000),
                  // 테두리 색상
                  width: 1.0, // 테두리 두께
                ),
              ),
            ),
            onPressed: () async {
              print('버튼 클릭');
              int followingMemberId = int.parse(await Helpers.getMemberId());

              widget.setFollow(widget.filteredFollowItem!.followMemberId, followingMemberId);

              setState(() {
                widget.filteredFollowItem!.isFollow = !widget.filteredFollowItem!.isFollow!;
              });
            },
            child: widget.isFollowingItem
                ? Text(
              !widget.filteredFollowItem!.isFollow! ? "언팔로우" : '팔로우',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            )
                : Text(
              widget.filteredFollowItem!.isFollowedCd == 0
                  ? widget.filteredFollowItem!.isFollow! ? "언팔로우" : '팔로우'
                  : widget.filteredFollowItem!.isFollowedCd == 1
                  ? widget.filteredFollowItem!.isFollow! ? "팔로우" : '언팔로우'
                  : widget.filteredFollowItem!.isFollowedCd == 3
                  ? widget.filteredFollowItem!.isFollow! ? '맞팔로우' : '언팔로우'
                  : widget.filteredFollowItem!.isFollowedCd == 2
                  ? widget.filteredFollowItem!.isFollow! ? '언팔로우' : '맞팔로우' : 'null',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
