import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';


class PlayListSquareItem extends StatefulWidget {
  const PlayListSquareItem({
    super.key,
    required this.playList,
  });

  
  final List<PlayListInfoModel> playList;

  @override
  State<PlayListSquareItem> createState() => _PlayListSquareItemState();
}

class _PlayListSquareItemState extends State<PlayListSquareItem> {
  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.only(left: 10,right: 0),
      child: Wrap(
        spacing: 20.0, // 아이템 간의 가로 간격
        runSpacing: 20.0, // 줄 간격
        alignment: WrapAlignment.spaceBetween,
        children: widget.playList.map((item) {

          return Container(
            width: 44.w,
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width: 2),
              borderRadius: BorderRadius.circular(10)
            ),
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/playList',extra: item);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CustomCachedNetworkImage(
                            imagePath: item.playListImagePath,
                            imageWidth: 39.w,
                            imageHeight: 20.h),
                      ),

                      Container(
                        width: 39.w,
                        height: 20.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9), // 하단은 어두운 색
                                Colors.transparent, // 상단은 투명
                              ],
                              stops: [0, 1.0],
                            ),
                          ),
                        ),

                      Positioned(
                          top : 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child:  ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: CustomCachedNetworkImage(imagePath: item.playListImagePath, imageWidth: 15.w, imageHeight: 7.h),
                          ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        item.playListNm!,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (item.isPlayListPrivacy == true)...[
                        SizedBox(width: 4,),
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 13,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 3,),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            item.trackCnt.toString() + " tracks",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            item.totalPlayTime.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: 7,),


                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            width: 15,
                            height: 15,
                            item.isPlayListLike! ? 'assets/images/heart_red.svg' : 'assets/images/heart.svg',
                          ),
                          SizedBox(width: 2,),
                          Text(
                            item.playListLikeCnt.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  SizedBox(height: 3,),
                  Container(
                    width: 39.w,
                    child: Row(
                      children: [
                        ClipOval(
                          child: CustomCachedNetworkImage(
                            imagePath: item.memberImagePath,
                            imageWidth: 4.5.w,
                            imageHeight: null,
                          ),
                        ),
                        SizedBox(width: 5,),

                        Text(
                          item.memberNickName ?? "",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
