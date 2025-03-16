import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';


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
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey,width: 2),
          borderRadius: BorderRadius.circular(10)
      ),
      child: GestureDetector(
        onTap: () {
          print('음원상세 클릭');
          GoRouter.of(context).push('/musicInfo/${widget.track.trackId}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomCachedNetworkImage(
                    imagePath: widget.track.trackImagePath,
                    imageWidth : 40.w,
                    imageHeight : 20.h
                ),
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

            SizedBox(height: 10),
            Container(
              width: 160,
              child: Row(
                children: [
                  Text(
                    widget.track.trackNm!,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.track.trackPrivacy == true)...[
                    SizedBox(width: 4,),
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 13,
                    ),
                  ],
                ],
              ),
            ),

            if(widget.track.memberNickName != null && widget.track.trackTime == null)
              Text(
                widget.track.memberNickName ?? "",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),

            if(widget.track.memberNickName == null && widget.track.trackTime != null)
              Text(
                widget.track.trackTime ?? "",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),

          ],
        ),
      ),
    );
  }
}
