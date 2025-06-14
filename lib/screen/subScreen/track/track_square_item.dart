import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/graph/track_bar_graph_animation.dart';

class TrackSquareItem extends StatefulWidget {
  const TrackSquareItem({
    super.key,
    required this.trackItem,
    required this.trackItemIdx,
    required this.initAudioPlayerTrackListCallBack,
    required this.appScreenName,
  });

  final Track trackItem;
  final int? trackItemIdx;
  final Function initAudioPlayerTrackListCallBack;
  final String? appScreenName;

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
          trackProv.initCurrentTrackPlaying(playerProv.playerModel.currentPage);

          if (playerProv.playerModel.currentAppScreen != widget.appScreenName) {
            playerProv.playerModel.currentAppScreen = widget.appScreenName;
            await playerProv.initAudioPlayer(trackProv, widget.initAudioPlayerTrackListCallBack, widget.trackItemIdx);
          } else {
            await playerProv.reloadDeleteTrack(trackProv,widget.trackItem,widget.trackItemIdx!);
          }

          playerProv.playerModel.isPlaying = true;
          await playerProv.updateAudioPlayerSwiper(widget.trackItem.trackId!,trackProv);

          playerProv.notify();

        } else {
          GoRouter.of(context).push('/trackInfo',
            extra: {
              'track': widget.trackItem,
              'commendId': null,
            },
          );
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

                  if (widget.trackItem.isPlaying)...[
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
                  GoRouter.of(context).push('/trackInfo',
                    extra: {
                      'track': widget.trackItem,
                      'commendId': null,
                    },
                  );
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
                GoRouter.of(context).push('/memberPage/${widget.trackItem.memberId}');
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


          ],
        ),
      ),
    );
  }
}
