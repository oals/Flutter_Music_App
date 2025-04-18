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
import 'package:skrrskrr/screen/subScreen/comn/track_bar_graph_animation.dart';
import 'package:skrrskrr/utils/helpers.dart';


class TrackSquareItem extends StatefulWidget {
  const TrackSquareItem({
    super.key,
    required this.trackItem,
    required this.callBack,
  });

  final Track trackItem;
  final Function callBack;

  @override
  State<TrackSquareItem> createState() => _TrackSquareItemState();
}

class _TrackSquareItemState extends State<TrackSquareItem> {

  late TrackProv trackProv;
  late PlayerProv playerProv;

  @override
  Widget build(BuildContext context) {

    trackProv = Provider.of<TrackProv>(context);
    playerProv = Provider.of<PlayerProv>(context);

    return GestureDetector(
      onTap: () async {
        if (!widget.trackItem.isPlaying) {
          widget.trackItem.isPlaying = true;
          await trackProv.setLastListenTrackId(widget.trackItem.trackId!);

          await widget.callBack();

          trackProv.audioPlayerTrackList[playerProv.currentPage].isPlaying = false;
          await trackProv.getAudioPlayerTrackList();

          int index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId.toString() == trackProv.lastTrackId);
          if (index != -1) {
            trackProv.audioPlayerTrackList[index].isPlaying = true;

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              playerProv.page = index;
              playerProv.swiperController.move(index, animation: true);
            });
          }

          trackProv.notify();
          playerProv.notify();

        } else {
          GoRouter.of(context).push('/musicInfo', extra: widget.trackItem);
        }

      },
      child: Container(
        width: 45.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Stack(
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CustomCachedNetworkImage(
                        imagePath: widget.trackItem.trackImagePath,
                        imageWidth : 45.w,
                        imageHeight : null,
                        isBoxFit: true,
                    ),
                  ),

                  if(widget.trackItem.isPlaying)...[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        width: 45.w,
                      ),
                    ),

                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: TrackBarGraphAnimation(isPlaying: playerProv.playerModel.isPlaying),
                    ),
                  ],

                  if (widget.trackItem.isTrackPrivacy == true)...[
                    Positioned(
                      top: 10,
                      right: 5,
                      child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 15
                      ),
                    ),
                  ],



                ],
              ),
            ),

            SizedBox(height: 6,),
            Container(
              width: 39.w,
              child: GestureDetector(
                onTap: () {
                  print('음원상세 클릭');
                  GoRouter.of(context).push('/musicInfo',extra: widget.trackItem);
                },
                child: Text(
                  '${widget.trackItem.trackNm}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/userPage/${widget.trackItem.memberId}');
                },
              child: Text(
                widget.trackItem.memberNickName ?? "",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),


            //
            //
            // Row(
            //   children: [
            //
            //     Row(
            //       children: [
            //         SvgPicture.asset(
            //           'assets/images/play.svg',
            //           width: 3.w,
            //           color: Colors.grey,
            //         ),
            //         SizedBox(width: 3,),
            //         Text(
            //           widget.track.trackPlayCnt.toString(),
            //           style: TextStyle(
            //             fontSize: 17,
            //             color: Colors.white,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //       ],
            //     ),
            //
            //     SizedBox(width: 5,),
            //     Row(
            //       children: [
            //         SvgPicture.asset(
            //           widget.track.trackLikeStatus == true
            //               ? 'assets/images/heart_red.svg'
            //               : 'assets/images/heart.svg',
            //           width: 4.5.w,
            //         ),
            //         SizedBox(width: 3,),
            //         Text(
            //           widget.track.trackLikeCnt.toString(),
            //           style: TextStyle(
            //             fontSize: 17,
            //             color: Colors.white,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //       ],
            //     ),
            //
            //
            //
            //     ],
            // ),
            //
            // Row(
            //   children: [
            //     Text(
            //       widget.track.trackTime.toString(),
            //       style: TextStyle(
            //         color: Colors.grey,
            //         fontSize: 14,
            //       ),
            //     ),
            //     SizedBox(width: 5,),
            //     Text(
            //       Helpers.getCategory(widget.track.trackCategoryId!),
            //       style: TextStyle(
            //         color: Colors.grey,
            //         fontSize: 14,
            //       ),
            //     ),
            //
            //   ],
            // ),
            //
            // Row(
            //     children: [
            //       ClipOval(
            //         child: CustomCachedNetworkImage(
            //           imagePath: widget.track.memberImagePath,
            //           imageWidth: 4.5.w,
            //           imageHeight: null,
            //           isBoxFit: true,
            //         ),
            //       ),
            //       SizedBox(width: 5,),
            //       GestureDetector(
            //         onTap: () {
            //           GoRouter.of(context).push('/userPage/${widget.track.memberId}');
            //         },
            //         child: Text(
            //           widget.track.memberNickName ?? "",
            //           style: TextStyle(
            //             fontSize: 15,
            //             color: Colors.grey,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),



          ],
        ),
      ),
    );
  }
}
