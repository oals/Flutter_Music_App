import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

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
                      GoRouter.of(context).push('/memberPage/${widget.memberList[i].followMemberId}');
                    },
                    child: Container(
                      width: 25.w,
                      height: 12.5.h,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: ClipOval(
                        child: CustomCachedNetworkImage(
                            imagePath:widget.memberList![i].followImagePath,
                            imageWidth : 25.w,
                            imageHeight : 12.5.h,
                          isBoxFit: true,
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height: 8),

                  if (widget.memberList![i].isFollowedCd == 2 || widget.memberList![i].isFollowedCd == 3)
                    Text(
                      'This account follows you.',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                      ),
                    ),

                  Text(
                    widget.memberList[i].followNickName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700
                    ),
                  ),

                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Color(0xFF1C1C1C)),
                        shadowColor: WidgetStateProperty.all(Colors.transparent),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
                        )),
                      ),
                      onPressed: () async {

                        int followerId = int.parse(await ComnUtils.getMemberId());

                        await followProv.setFollow(followerId,widget.memberList![i].followMemberId);

                        if (widget.memberList![i].isFollowedCd == 0) {
                          widget.memberList![i].isFollowedCd = 1;
                        } else if (widget.memberList![i].isFollowedCd == 1) {
                          widget.memberList![i].isFollowedCd = 0;
                        } else if (widget.memberList![i].isFollowedCd == 2) {
                          widget.memberList![i].isFollowedCd = 3;
                        } else if (widget.memberList![i].isFollowedCd == 3) {
                          widget.memberList![i].isFollowedCd = 2;
                        }
                        setState(() {});
                      },
                      child: Text(
                        widget.memberList![i].isFollowedCd == 1 ||  widget.memberList![i].isFollowedCd == 3
                            ? "Unfollow"
                            : 'Follow',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),


                    ),
                  ),
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
