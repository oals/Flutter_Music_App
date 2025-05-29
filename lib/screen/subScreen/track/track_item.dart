
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/handler/audio_back_state_handler.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/graph/track_bar_graph_animation.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class TrackItem extends StatefulWidget {
  const TrackItem({
    super.key,
    required this.trackItem,
    required this.trackItemIdx,
    required this.initAudioPlayerTrackListCallBack,
    required this.isAudioPlayer,
    required this.appScreenName,
  });

  final Track trackItem;
  final int? trackItemIdx;
  final Function initAudioPlayerTrackListCallBack;
  final bool isAudioPlayer;
  final String? appScreenName;


  @override
  State<TrackItem> createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
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
          if (widget.appScreenName != "AudioPlayerTrackListModal") {

            trackProv.initCurrentTrackPlaying(playerProv.playerModel.currentPage);

            if (playerProv.playerModel.currentAppScreen != widget.appScreenName) {
              playerProv.playerModel.currentAppScreen = widget.appScreenName;
              await playerProv.initAudioPlayer(trackProv, widget.initAudioPlayerTrackListCallBack, widget.trackItemIdx);
            } else {
              await playerProv.reloadDeleteTrack(trackProv,widget.trackItem,widget.trackItemIdx!);
            }
          }

          playerProv.playerModel.isPlaying = true;
          await playerProv.updateAudioPlayerSwiper(widget.trackItem.trackId!, trackProv);

          playerProv.notify();

        } else {
          if (widget.appScreenName != 'AudioPlayerTrackListModal') {
            GoRouter.of(context).push('/trackInfo',
              extra: {
                'track': widget.trackItem,
                'commendId': null,
              },
            );
          }
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [

                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 2),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // 원하는 둥글기 조정
                            child: CustomCachedNetworkImage(
                                imagePath: widget.trackItem.trackImagePath,
                                imageWidth : 15.w,
                                imageHeight : null,
                                isBoxFit: true,
                            ),

                          ),
                        ),

                        if (widget.trackItem.isTrackPrivacy!)
                          Positioned(
                            top: 10,
                            right: 6,
                            child: Icon(Icons.lock,color: Colors.white,size: 15,),
                          ),

                        if (widget.trackItem.isPlaying)...[
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              width: 15.w,
                              height: 15.w,
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

                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            width: 57.w,
                            child: GestureDetector(
                              onTap: (){
                                if (widget.appScreenName != 'AudioPlayerTrackListModal') {
                                  GoRouter.of(context).push('/trackInfo',
                                    extra: {
                                      'track': widget.trackItem,
                                      'commendId': null,
                                    },
                                  );
                                }
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
                          SizedBox(height: 2,),
                          Row(
                            children: [

                              Text(
                                '${widget.trackItem.trackTime}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(width: 3,),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/play.svg',
                                    width: 11,
                                    height: 11,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 1,),
                                  Text(
                                    '${widget.trackItem.trackPlayCnt}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5,),
                              Row(
                                children: [

                                  SvgPicture.asset(
                                    widget.trackItem.isTrackLikeStatus! ? 'assets/images/heart_red.svg' : 'assets/images/heart.svg',
                                    width: 15,
                                    height: 15,
                                  ),
                                  SizedBox(width: 1,),
                                  Text(
                                    '${widget.trackItem.trackLikeCnt}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 1,),
                          Text(
                            '#'+ ComnUtils.getCategory(widget.trackItem.trackCategoryId!),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: 3,),
                            Row(
                              children: [
                                Container(
                                  width: 3.5.w,
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: ClipOval(
                                    child: CustomCachedNetworkImage(
                                      imagePath: widget.trackItem.memberImagePath,
                                      imageWidth: 3.5.w,
                                      imageHeight: null,
                                      isBoxFit: true,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3,),
                                GestureDetector(
                                  onTap: (){
                                    if (!widget.isAudioPlayer) {
                                      GoRouter.of(context).push('/memberPage/${widget.trackItem.memberId}');
                                    }
                                  },
                                  child: Text(
                                    '${widget.trackItem.memberNickName}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (!widget.isAudioPlayer)
                  GestureDetector(
                  onTap: () async {
                   await AppBottomModalRouter().fnModalRouter(context,3, track : widget.trackItem,);
                  },
                  child: SvgPicture.asset(
                    'assets/images/ellipsis.svg',
                    color: Colors.grey,
                  ),
                ),


              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.09,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
