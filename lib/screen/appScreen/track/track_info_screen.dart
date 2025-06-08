import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/button/share_btn_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/slider/circular_slider_track_shape.dart';
import 'package:skrrskrr/screen/subScreen/comn/button/track_comment_btn_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/button/track_like_btn_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class TrackInfoScreen extends StatefulWidget {
  const TrackInfoScreen({
    super.key,
    required this.track,
    required this.commentId,
  });

  final Track track;
  final int? commentId;

  @override
  State<TrackInfoScreen> createState() => _TrackInfoScreenState();
}

class _TrackInfoScreenState extends State<TrackInfoScreen> {
  late String? loginMemberId;
  bool isAuth = false;
  bool isEdit = false;

  late TrackProv trackProv;
  late PlayerProv playerProv;
  late Future<bool> _getTrackInfoFuture;

  @override
  void initState() {
    print("MusicInfoScreen initstate");
    super.initState();
    _getTrackInfoFuture = Provider.of<TrackProv>(context, listen: false).getTrackInfo(widget.track.trackId);
    _loadMemberId();

    if (widget.commentId != null) {
      Future.delayed(Duration(milliseconds: 700), () async {
        await AppBottomModalRouter().fnModalRouter(context, 0, trackId: widget.track.trackId,commentId: widget.commentId);
      });
    }
  }

  void _loadMemberId() async {
    loginMemberId = await ComnUtils.getMemberId();
  }


  @override
  Widget build(BuildContext context) {

    trackProv = Provider.of<TrackProv>(context);
    playerProv = Provider.of<PlayerProv>(context,listen: false);
    FollowProv followProv = Provider.of<FollowProv>(context);

    return Scaffold(
      body: Container(
        color: Color(0xff000000),
        width: 100.w,
        child: FutureBuilder<bool>(
          future: _getTrackInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            widget.track.updateApiData(trackProv.trackInfoModel);
            trackProv.trackInfoModel = widget.track;
            isAuth = ComnUtils.getIsAuth(widget.track.memberId.toString(), loginMemberId!);
      
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 68.h,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (isAuth) {
                                    trackProv.trackInfoModel.trackImagePath = await ComnUtils.pickImage(trackProv.trackInfoModel.trackId, false, context);
                                    setState(() {});
                                  }
                                },
                                child: CustomCachedNetworkImage(
                                  imagePath: widget.track.trackImagePath,
                                  imageWidth : 100.w,
                                  imageHeight : 50.h,
                                  isBoxFit: true,
                                ),

                              ),

                              Container(
                                width: 100.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                    stops: [0.1, 1.0],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isEdit)...[
                                      GestureDetector(
                                        onTap:() async {
                                          String? newTrackImagePath = await ComnUtils.pickImage(trackProv.trackInfoModel.trackId, false, context);
                                          if (newTrackImagePath != null) {
                                            trackProv.trackInfoModel.trackImagePath = newTrackImagePath;
                                            setState(() {});
                                          }
                                        },
                                        child: Text(
                                          'Change Image',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                    
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  right : 0,
                                  child: CustomAppbar(
                                    fnBackBtnCallBack: ()=>{GoRouter.of(context).pop()},
                                    fnUpdateBtnCallBack:()=>{
                                      setState(() {
                                        isEdit = !isEdit;
                                      }),
                                    },

                                    title: "",
                                    isNotification: true,
                                    isEditBtn: isAuth,
                                    isAddTrackBtn : false,
                                  )
                              ),
                    
                              Positioned.fill(
                                top: 41.h,
                                left: 10,
                                right: 15,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              SizedBox(
                                                width: 80.w,
                                                child: Text(
                                                  widget.track.trackNm ?? "null",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.w800),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              Text(
                                                widget.track.memberNickName ?? "null",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Transform.translate(
                                                offset: Offset(-4, 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.play_arrow_sharp,
                                                      color: Colors.grey,
                                                      size: 17,
                                                    ),
                                                    Text(
                                                      ' ${widget.track.trackPlayCnt} plays ',
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                widget.track.trackCategoryId == null
                                                    ? "null"
                                                    : "#" + ComnUtils.getCategory(widget.track.trackCategoryId!),
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                widget.track.trackTime ?? "null",
                                                style:
                                                TextStyle(color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                widget.track.trackUploadDate ??
                                                    "null",
                                                style:
                                                TextStyle(color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),

                                          Consumer<PlayerProv>(
                                              builder: (context, PlayerProv, child) {
                                                return Container(
                                                  margin: EdgeInsets.only(top: 2.5.h) ,
                                                  child: Row(
                                                    children: [
                                                        Stack(
                                                          children: [
                                                              Positioned(
                                                              left: 1,
                                                              right: 1,
                                                              child: SliderTheme(
                                                                data: SliderThemeData(
                                                                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                                                                  trackShape: CircularSliderTrackShape(
                                                                    progress: trackProv.lastTrackId == widget.track.trackId.toString() ?
                                                                    playerProv.playerModel.totalDuration.inSeconds > 0
                                                                        ? playerProv.playerModel.currentPosition.inSeconds / playerProv.playerModel.totalDuration.inSeconds
                                                                        : 0.0
                                                                    : 0.0,
                                                                  ),
                                                                  trackHeight: 3.5,
                                                                ),
                                                                child: Slider(
                                                                  value: trackProv.lastTrackId == widget.track.trackId.toString() ? 0 : playerProv.playerModel.currentPosition.inSeconds.toDouble(),
                                                                  min: 0.0,
                                                                  max: trackProv.lastTrackId == widget.track.trackId.toString() ? 0 : playerProv.playerModel.totalDuration.inSeconds.toDouble(),
                                                                  onChanged: null,
                                                                  onChangeEnd: null,
                                                                  activeColor: Colors.white,
                                                                  inactiveColor: Colors.grey,
                                                                ),
                                                              ),
                                                            ),

                                                            IconButton(
                                                                icon: Icon(
                                                                  trackProv.lastTrackId == widget.track.trackId.toString() ? playerProv.playerModel.isPlaying
                                                                      ? Icons.pause
                                                                      : Icons.play_arrow
                                                                  : Icons.play_arrow,
                                                                  size: 32,
                                                                  color: Colors.white,
                                                                ),
                                                                onPressed: () async {

                                                                  if (trackProv.lastTrackId != widget.track.trackId.toString()) {
                                                                    int index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId == widget.track.trackId);

                                                                    if (index == -1) {
                                                                      index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId.toString() == trackProv.lastTrackId);
                                                                      trackProv.audioPlayerTrackList.insert(index + 1, widget.track);
                                                                      await playerProv.addTrack(widget.track, index + 1);
                                                                      trackProv.notify();
                                                                    }

                                                                    List<int> trackIdList = trackProv.audioPlayerTrackList.map((item) => int.parse(item.trackId.toString())).toList();
                                                                    trackProv.setAudioPlayerTrackIdList(trackIdList);

                                                                    await playerProv.updateAudioPlayerSwiper(widget.track.trackId!,trackProv);
                                                                    playerProv.playerModel.isPlaying = false;
                                                                  }

                                                                  await playerProv.togglePlayPause(playerProv.playerModel.isPlaying, trackProv);

                                                                }
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              }
                                          ),
                                        ],
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TrackLikeBtnItem(track: widget.track),
                                            SizedBox(width: 10,),
                                            TrackCommentBtnItem( track : widget.track),
                                            SizedBox(width: 10,),

                                            ShareBtn(
                                                shareId: 2,
                                                shareItemId: widget.track.trackId!,
                                                imagePath: widget.track.trackImagePath ?? "",
                                                title: widget.track.trackNm!,
                                                info: "🎵 This track is too good not to share!"
                                            ),

                                          ],
                                        ),
                                        if (isEdit)...[
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              print('음원 소개 편집 버튼');

                                              await AppBottomModalRouter().fnModalRouter(
                                                  context,
                                                  1,
                                                  maxLines: null,
                                                  infoText: widget.track.trackInfo,
                                                  callBack: (String newTrackInfo) async {

                                                    bool isUpdate = await trackProv.setTrackInfo(newTrackInfo);

                                                    widget.track.trackInfo = newTrackInfo;

                                                    if (isUpdate) {
                                                      ComnUtils.customFlutterToast("Successfully completed");
                                                    } else {
                                                      ComnUtils.customFlutterToast("Please try again later");
                                                    }

                                                    setState(() {});
                                                  },
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/edit.svg',
                                              width: 24,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),


                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        /// 곡 정보
                        Container(
                          width: 98.w,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.track.trackInfo ?? "",
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: 5,),

                        Container(
                          padding: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).push('/memberPage/${widget.track.memberId}');
                                },
                                child: Column(
                                  children: [
                                      Container(
                                        width: 25.w,
                                        height: 12.5.h,
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.white10,
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                        child: ClipOval(
                                        child: CustomCachedNetworkImage(
                                            imagePath: widget.track.memberImagePath,
                                            imageWidth: 25.w,
                                            imageHeight: 12.5.h,
                                            isBoxFit: true,
                                          ),
                                        ),
                                      ),

                                    SizedBox(height: 8),
                                    Text(widget.track.memberNickName ??
                                        "null",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (!isAuth && !isEdit)
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Color(0xFF1C1C1C)),
                                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
                                    )),
                                  ),
                                  onPressed: () async {
                                    await followProv.setFollow(loginMemberId, widget.track.memberId,);
                                    widget.track.isFollowMember = !widget.track.isFollowMember!;
                                    setState(() {});
                                  },
                                  child: Text(
                                    widget.track.isFollowMember == true
                                        ? 'Unfollow'
                                        : 'Follow',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                  ),
                                ),
                            ],
                          ),
                        ),


                        SizedBox(height: 10.h,),
                      ],
                    ),
                  ),
                ),
               
            
            
            
            
              ],
            );
          },
        ),
      ),
    );
  }
}
