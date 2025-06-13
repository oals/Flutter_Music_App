import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/utils/comn_utils.dart';
import 'package:skrrskrr/utils/share_utils.dart';

class TrackInfoModal extends StatefulWidget {
  const TrackInfoModal({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<TrackInfoModal> createState() => _TrackInfoModalState();
}

class _TrackInfoModalState extends State<TrackInfoModal> {

  bool isImageLoad = false;
  bool isAuth = false;
  late String? loginMemberId;

  @override
  void initState() {
    super.initState();
    _loadMemberId();
  }

  void _loadMemberId() async {
    loginMemberId = await ComnUtils.getMemberId();
    isAuth = ComnUtils.getIsAuth(widget.track.memberId.toString(), loginMemberId!);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    PlayListProv playListProv = Provider.of<PlayListProv>(context);
    TrackProv trackProv = Provider.of<TrackProv>(context);

    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
       color: Colors.black
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, //0xff8515e7
              borderRadius: BorderRadius.circular(30),
            ),
            width: 50,
            height: 8,
          ),
          SizedBox(height: 25,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 3),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), // 원하는 둥글기 조정
                    child: CustomCachedNetworkImage(
                        imagePath:widget.track.trackImagePath,
                        imageWidth : 33.w,
                        imageHeight : 16.h,
                      isBoxFit: true,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Container(
                width: 48.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.track.trackNm!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 3,),
                    Text(widget.track.memberNickName ?? "",style: TextStyle(color: Colors.grey),),
                    SizedBox(height: 3,),
                    Text(
                      "#" + ComnUtils.getCategory(widget.track.trackCategoryId!),
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    SizedBox(height: 3,),
                    Transform.translate(
                      offset: Offset(-4, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_arrow_sharp,
                            color: Colors.grey,
                            size: 21.4,
                          ),
                          Text(widget.track.trackPlayCnt.toString(),style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                    SizedBox(height: 3,),
                    Row(
                      children: [
                        SvgPicture.asset(
                          width: 16,
                          height: 16,
                          widget.track.isTrackLikeStatus! ? 'assets/images/heart_red.svg' : 'assets/images/heart.svg',
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(widget.track.trackLikeCnt.toString(),style: TextStyle(color: Colors.white),),
                      ],
                    ),

                    SizedBox(height: 3,),
                    Text(widget.track.trackTime.toString(),style: TextStyle(color: Colors.grey),),
                    SizedBox(height: 3,),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          Container(
            width: 90.w,
            height: 0.6,
            color: Colors.grey,
          ),
          SizedBox(height: 7),

          GestureDetector(
            onTap: () async {
              print('좋아요 클릭');
              await trackProv.setTrackLike(widget.track.trackId);
              trackProv.fnUpdateTrackLikeStatus(widget.track);
              trackProv.notify();
            },
            child: Container(
              width: 94.w,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.track.isTrackLikeStatus!
                        ? 'assets/images/heart_red.svg'
                        : 'assets/images/heart.svg',
                    width: 24,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    'Liked',
                    style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

          ),
          GestureDetector(
            onTap: () async {
              print('플리에 추가 버튼 클릭');

              await AppBottomModalRouter(isChild: true).fnModalRouter(
                context,
                8,
                trackId: widget.track.trackId,
              callBack: (int? playListId) {
                if (playListId != null) {
                  playListProv.setPlayListTrack(playListId, widget.track.trackId!);
                }
              });

            },
            child: Container(
              width: 94.w,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.playlist_add,
                    color: Colors.white,
                    size: 27,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "Add to playlist",
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 94.w,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [

                GestureDetector(
                  onTap:() async {

                    await AppBottomModalRouter(isChild: true).fnModalRouter(
                        context,
                        9,
                        callBack: (String selectShareNm) async {

                          Map<String, String> shareMap = {
                            "title": widget.track.trackNm!,
                            "info":  "🎵 This track is too good not to share!",
                            "imagePath": widget.track.trackImagePath ?? "",
                            "shareId" : "2",
                            "shareItemId" : widget.track.trackId.toString(),
                            "selectShareNm" : selectShareNm,
                          };

                          await ShareUtils.sendToShareApp(shareMap, context);
                        });

                  },
                  child: Row(
                    children: [
                      Icon(Icons.share_rounded,color: Colors.white,size: 26,),

                      SizedBox(width: 5,),
                      Text(
                        "Share this track",
                        style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                )


              ],
            ),
          ),



        if (isAuth)
          GestureDetector(
            onTap: () async {
              await trackProv.setLockTrack(widget.track.trackId,!widget.track.isTrackPrivacy!);
              widget.track.isTrackPrivacy = !widget.track.isTrackPrivacy!;
              trackProv.notify();
            },
            child: Container(
              width: 94.w,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.lock_reset_outlined,color: Colors.white,size: 23,),

                  SizedBox(width: 5,),

                  Text(
                    widget.track.isTrackPrivacy! ? 'Set to Public' : "Set to Private",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
