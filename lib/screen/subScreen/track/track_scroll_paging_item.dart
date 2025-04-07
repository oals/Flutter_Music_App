import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/utils/helpers.dart';

class TrackScrollPagingItem extends StatefulWidget {
  const TrackScrollPagingItem({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<TrackScrollPagingItem> createState() => _TrackScrollPagingItemState();
}

class _TrackScrollPagingItemState extends State<TrackScrollPagingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10), // 아이템 간의 간격
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap : (){
                    GoRouter.of(context).push('/musicInfo',extra: widget.track);
                  },
                  child: Stack(
                    children: [
                      CustomCachedNetworkImage(
                        imagePath: widget.track.trackImagePath,
                        imageWidth: 18.w,
                        imageHeight: 9.h,
                      ),
                      Container(
                        width: 18.w,
                        height: 9.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.greenAccent.withOpacity(0.9),
                              Colors.transparent,
                            ],
                            stops: [0, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 13),
          Container(
            width: 60.w,
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.2,
                  color: Colors.grey,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 70.w,
                  child: Text(
                    widget.track.trackNm ?? "null", // 아이템 제목
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),


                SizedBox(width: 5,),
                Row(
                  children: [

                    Row(
                      children: [
                        SvgPicture.asset('assets/images/play.svg' ,
                          width: 12,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 3,),
                        Text(
                          widget.track.trackPlayCnt.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 5,),
                    Row(
                      children: [
                        SvgPicture.asset(
                          widget.track.trackLikeStatus!
                              ? 'assets/images/heart_red.svg'
                              : 'assets/images/heart.svg' ,
                          width: 15,
                        ),
                        SizedBox(width: 3,),
                        Text(
                          widget.track.trackLikeCnt.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Text(
                      widget.track.trackTime.toString(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      Helpers.getCategory(widget.track.trackCategoryId!),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    ClipOval(
                      child: CustomCachedNetworkImage(
                        imagePath: widget.track.memberImagePath,
                        imageWidth: 4.5.w,
                        imageHeight: null,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      widget.track.memberNickName ?? "null",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          SizedBox(width: 13),
        ],
      ),
    );
  }
}
