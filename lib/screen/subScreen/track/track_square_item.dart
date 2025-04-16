import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/utils/helpers.dart';


class TrackSquareItem extends StatefulWidget {
  const TrackSquareItem({
    super.key,
    required this.track,
    required this.bgColor,
  });

  final Track track;
  final Color bgColor;

  @override
  State<TrackSquareItem> createState() => _TrackSquareItemState();
}

class _TrackSquareItemState extends State<TrackSquareItem> {

  late TrackProv trackProv;
  late PlayerProv playerProv;

  @override
  Widget build(BuildContext context) {

    trackProv = Provider.of<TrackProv>(context);
    playerProv = Provider.of<PlayerProv>(context,listen: false);


    return GestureDetector(
      onTap: () async {
        await trackProv.setLastListenTrackId(widget.track.trackId!);
        await playerProv.setAudioPlayer(trackProv);
      },
      child: Container(
        width: 44.w,
        padding: EdgeInsets.only(left: 5,bottom: 10,right: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 2),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomCachedNetworkImage(
                        imagePath: widget.track.trackImagePath,
                        imageWidth : 40.w,
                        imageHeight : 20.h
                    ),
                  ),

                  if (widget.track.trackPrivacy == true)...[
                    Positioned(
                      top: 10,
                      right: 5,
                      child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 25
                      ),
                    ),
                  ],


                  Container(
                    width: 40.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          widget.bgColor.withOpacity(0.9), // 하단은 어두운 색
                          Colors.transparent, // 상단은 투명
                        ],
                        stops: [0, 1.0],
                      ),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 10),
            Container(
              width: 39.w,
              child: GestureDetector(
                onTap: () {
                  print('음원상세 클릭');
                  GoRouter.of(context).push('/musicInfo',extra: widget.track);
                },
                child: Text(
                  '${widget.track.trackNm}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),


            Row(
              children: [

                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/play.svg',
                      width: 3.w,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 3,),
                    Text(
                      widget.track.trackPlayCnt.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 5,),
                Row(
                  children: [
                    SvgPicture.asset(
                      widget.track.trackLikeStatus == true
                          ? 'assets/images/heart_red.svg'
                          : 'assets/images/heart.svg',
                      width: 4.5.w,
                    ),
                    SizedBox(width: 3,),
                    Text(
                      widget.track.trackLikeCnt.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),



                ],
            ),

            Row(
              children: [
                Text(
                  widget.track.trackTime.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 5,),
                Text(
                  Helpers.getCategory(widget.track.trackCategoryId!),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

              ],
            ),

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
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/userPage/${widget.track.memberId}');
                    },
                    child: Text(
                      widget.track.memberNickName ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),



          ],
        ),
      ),
    );
  }
}
