import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

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

    return Container(
      padding: EdgeInsets.only(top : 5, bottom : 5,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              GoRouter.of(context).push('/memberPage/${widget.filteredFollowItem?.followMemberId}');
            },
            child: Row(
              children: [

                Container(
                  width: 13.w,
                  padding: EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: ClipOval(
                    child: CustomCachedNetworkImage(
                      imagePath: widget.filteredFollowItem!.followImagePath,
                      imageWidth : 13.w,
                      imageHeight : null,
                      isBoxFit: true,
                    ),
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

                    if (widget.isSearch)
                      if (widget.filteredFollowItem!.isFollowedCd == 3)
                        Text(
                          'This account follows you',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),

                    if (!widget.isSearch && widget.isFollowingItem)
                      if (widget.filteredFollowItem!.isFollowedCd == 3)
                        Text(
                          'This account follows you',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),

                    if (!widget.isSearch && !widget.isFollowingItem)
                      if (widget.filteredFollowItem!.isFollowedCd == 1 || widget.filteredFollowItem!.isFollowedCd == 3)
                        Text(
                          'Following this account',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),

                  ],
                ),
              ],
            ),
          ),

            ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),  // 모서리 둥글지 않게 설정 (네모 형태)
                ),
              ),
              backgroundColor: WidgetStateProperty.all(Color(0xff1c1c1c)),

              side: WidgetStateProperty.all(
                BorderSide(
                  color: Color(0xff000000),
                  width: 1.0, // 테두리 두께
                ),
              ),
            ),
            onPressed: () async {
              print('버튼 클릭');
              int followerId = int.parse(await ComnUtils.getMemberId());

              widget.setFollow(followerId,widget.filteredFollowItem!.followMemberId);

              widget.filteredFollowItem!.isFollow = !widget.filteredFollowItem!.isFollow!;
              setState(() {});
            },
            child: Text(
              widget.filteredFollowItem!.isFollow!
                    ? "Unfollow"
                    : 'Follow',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700),
              )
          ),
        ],
      ),
    );
  }
}
