import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/player/player.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/bottomNavigatorBar/custom_audio_player_bottom_navigation.dart';
import 'package:skrrskrr/screen/subScreen/comn/slider/circular_slider_track_shape.dart';

class AudioPlayerItem extends StatefulWidget {
  const AudioPlayerItem({
    super.key,
    required this.audioPlayerTrackItem
  });

  final Track audioPlayerTrackItem;

  @override
  State<AudioPlayerItem> createState() => _AudioPlayerItemState();
}

class _AudioPlayerItemState extends State<AudioPlayerItem> {

  late TrackProv trackProv;
  late AppProv appProv;
  late PlayerModel playerModel;
  late PlayerProv playerProv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appProv = Provider.of<AppProv>(context);
    playerProv = Provider.of<PlayerProv>(context, listen: false);
    trackProv = Provider.of<TrackProv>(context, listen: false);
    playerModel = playerProv.playerModel;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff000000), // 상단의 연한 색 (색상값을 조정하세요)
            Color(0xff1c1c1c), // 하단의 어두운 색 (현재 색상)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ValueListenableBuilder<bool>(
          valueListenable: playerProv.audioPlayerNotifier,
          builder: (context, value, child) {

            return GestureDetector(
              onPanUpdate: (details) {
                playerProv.handleDragUpdate(details);
              },
              onPanEnd: (details) {
                appProv.isFullScreenFunc(
                    playerProv.handleDragEnd());
              },
              onTap: () {
                playerProv.setFullScreen();
                appProv.isFullScreenFunc(true);
              },
              child: SingleChildScrollView(
                child: Container(
                  width: 100.w,
                  color: Colors.black,
                  child: Column(
                    children: [
                      if(appProv.isFullScreen)
                        Container(
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Color(0xff000000),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .start,
                            children: [
                              Stack(
                                children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius
                                        .only(
                                      bottomLeft: Radius
                                          .circular(35),
                                      bottomRight: Radius
                                          .circular(35),
                                    ),

                                    child: GestureDetector(
                                      child: CustomCachedNetworkImage(
                                        imagePath: widget.audioPlayerTrackItem
                                            .trackImagePath,
                                        imageWidth: 100.w,
                                        imageHeight: 93.h,
                                        isBoxFit: true,
                                      ),
                                    ),
                                  ),


                                  GestureDetector(
                                    onTap: () {
                                      playerProv
                                          .togglePlayPause(
                                          playerModel
                                              .isPlaying);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 100.w,
                                      height: 99.h,
                                      color: Colors
                                          .transparent,
                                    ),
                                  ),


                                  if(!playerModel.isPlaying)
                                    GestureDetector(
                                      onTap: () {
                                        playerProv
                                            .togglePlayPause(
                                            playerModel
                                                .isPlaying);
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 100.w,
                                        height: 93.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment
                                                .bottomCenter,
                                            end: Alignment
                                                .topCenter,
                                            colors: [
                                              Colors
                                                  .transparent
                                                  .withOpacity(
                                                  0.5),
                                              // 하단은 어두운 색
                                              Colors
                                                  .transparent,
                                              // 상단은 투명
                                            ],
                                            stops: [1, 1],
                                          ),
                                        ),
                                      ),
                                    ),

                                  Positioned(
                                    top: 42.h,
                                    left: 40.w,
                                    child: Center(
                                      child: Selector<PlayerProv, bool>(
                                          selector: (context, value) =>
                                          playerProv.playerModel.isBuffering,
                                          builder: (context, value, child) {
                                            return Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    value
                                                        ? CircularProgressIndicator()
                                                        : IconButton(
                                                      icon: Icon(
                                                        !playerModel
                                                            .isPlaying
                                                            ? Icons
                                                            .pause
                                                            : null,
                                                        size: 48,
                                                        color: Colors
                                                            .white,
                                                      ),
                                                      onPressed: () {
                                                        playerProv
                                                            .togglePlayPause(
                                                            playerModel
                                                                .isPlaying);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }
                                      ),
                                    ),
                                  ),


                                  Positioned(
                                    top: 7.h,
                                    right: 2.w,
                                    left: 0.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets
                                              .only(
                                              left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  print(
                                                      '해당 곡 정보 페이지로 이동');

                                                  playerProv
                                                      .playerModel
                                                      .fullScreen =
                                                  false;
                                                  appProv
                                                      .isFullScreenFunc(
                                                      false);
                                                  GoRouter
                                                      .of(
                                                      context)
                                                      .push(
                                                      '/musicInfo',
                                                      extra: widget.audioPlayerTrackItem);
                                                },
                                                child: SizedBox(
                                                  width: 70
                                                      .w,
                                                  child: Text(
                                                    widget.audioPlayerTrackItem
                                                        .trackNm ??
                                                        "잠시 후 다시 시도해주세요.",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  print(
                                                      '해당 유저 페이지로 이동');
                                                  playerProv
                                                      .playerModel
                                                      .fullScreen =
                                                  false;
                                                  appProv
                                                      .isFullScreenFunc(
                                                      false);

                                                  GoRouter
                                                      .of(
                                                      context)
                                                      .push(
                                                      '/userPage/${widget.audioPlayerTrackItem
                                                          .memberId}');
                                                },
                                                child: Text(
                                                  widget.audioPlayerTrackItem
                                                      .memberNickName ??
                                                      "잠시 후 다시 시도해주세요.",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight
                                                        .w600,
                                                    color: Colors
                                                        .grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: () {
                                            playerProv
                                                .playerModel
                                                .fullScreen =
                                            false;
                                            appProv
                                                .isFullScreenFunc(
                                                false);
                                            setState(() {});
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    100),
                                                color: Colors
                                                    .black,
                                              ),
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down_sharp,
                                                color: Colors
                                                    .white,
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Positioned(
                                    top: 80.h,
                                    left: 0,
                                    right: 0,
                                    child: Consumer<
                                        PlayerProv>(
                                        builder: (context,
                                            playerProv,
                                            child) {
                                          return ValueListenableBuilder<Duration>(
                                            valueListenable: playerModel.positionNotifier,
                                            builder: (
                                                context,
                                                position,
                                                child) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .end,
                                                children: [
                                                  Slider(
                                                    value: playerModel
                                                        .currentPosition
                                                        .inSeconds
                                                        .toDouble(),
                                                    min: 0.0,
                                                    max: playerModel
                                                        .totalDuration
                                                        .inSeconds
                                                        .toDouble(),
                                                    onChanged: playerProv
                                                        .playerModel
                                                        .isBuffering
                                                        ? null
                                                        : (
                                                        value) {
                                                      playerModel
                                                          .currentPosition =
                                                          Duration(
                                                              seconds: value
                                                                  .toInt());
                                                      setState(() {});
                                                    },
                                                    onChangeEnd: playerModel
                                                        .isBuffering
                                                        ? null
                                                        : playerProv
                                                        .onSliderChangeEnd,
                                                    activeColor: Colors
                                                        .white,
                                                    inactiveColor: Colors
                                                        .grey,
                                                  ),

                                                  Container(
                                                    padding:
                                                    EdgeInsets
                                                        .only(
                                                        left: 20,
                                                        right: 30),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${playerModel
                                                              .currentPosition
                                                              .toString()
                                                              .split(
                                                              '.')
                                                              .first}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        Text(
                                                          '${playerModel
                                                              .totalDuration
                                                              .toString()
                                                              .split(
                                                              '.')
                                                              .first}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                    ),
                                  ),


                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: CustomAudioPlayerBottomNavigation(
                                      commentsCnt: widget.audioPlayerTrackItem
                                          .commentsCnt,
                                      currentIndex: appProv
                                          .currentIndex,
                                      trackInfoModel: widget.audioPlayerTrackItem,
                                      onTap: (index) async {
                                        appProv.currentIndex = index;
                                        if (index == 2) {
                                          print("플리 팝업");
                                          AppBottomModalRouter.fnModalRouter(context, 7);
                                        } else
                                        if (index == 3) {
                                          AppBottomModalRouter.fnModalRouter(context, 3, track: widget.audioPlayerTrackItem);
                                        }
                                      },
                                    ),
                                  ),


                                ],
                              ),
                            ],
                          ),
                        ),

                      if(!appProv.isFullScreen)
                        Container(
                          height: 10.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius
                                .circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff000000),
                                // 상단의 연한 색 (색상값을 조정하세요)
                                Color(0xff1c1c1c),
                                // 하단의 어두운 색 (현재 색상)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          width: 100.w,
                          padding: EdgeInsets.only(left: 10,
                              right: 10,
                              top: 10,
                              bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment
                                .center,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius
                                        .circular(15.0),
                                    // 원하는 둥글기 조정
                                    child: CustomCachedNetworkImage(
                                      imagePath: widget.audioPlayerTrackItem
                                          .trackImagePath,
                                      imageWidth: 14.w,
                                      imageHeight: 14.h,
                                      isBoxFit: true,
                                    ),

                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [

                                      SizedBox(
                                        width: 60.w,
                                        child: Text(
                                          widget.audioPlayerTrackItem
                                              .trackNm ??
                                              "null.",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight
                                                .w600,
                                            color: Colors
                                                .white,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis,
                                        ),
                                      ),

                                      Text(
                                        widget.audioPlayerTrackItem
                                            .memberNickName ??
                                            "null",
                                        style: TextStyle(
                                            color: Colors
                                                .grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight
                                                .w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Consumer<PlayerProv>(
                                  builder: (context, PlayerProv, child) {
                                    return Container(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        children: [
                                          if (!playerProv.playerModel.fullScreen)
                                            Stack(
                                              children: [

                                                Positioned(
                                                  left: 1,
                                                  right: 1,
                                                  child: SliderTheme(
                                                    data: SliderThemeData(
                                                      thumbShape: RoundSliderThumbShape(
                                                          enabledThumbRadius: 0.0),
                                                      trackShape: CircularSliderTrackShape(
                                                        progress: playerModel
                                                            .totalDuration
                                                            .inSeconds >
                                                            0
                                                            ? playerModel
                                                            .currentPosition
                                                            .inSeconds /
                                                            playerModel
                                                                .totalDuration
                                                                .inSeconds
                                                            : 0.0, // 진행 비율 계산
                                                      ),

                                                      trackHeight: 3.5, // 트랙의 두께
                                                    ),
                                                    child: Slider(
                                                      value: playerModel
                                                          .currentPosition
                                                          .inSeconds
                                                          .toDouble(),
                                                      min: 0.0,
                                                      max: playerModel
                                                          .totalDuration
                                                          .inSeconds
                                                          .toDouble(),
                                                      onChanged: null,
                                                      onChangeEnd: null,
                                                      activeColor: Colors
                                                          .white,
                                                      inactiveColor: Colors
                                                          .grey,
                                                    ),
                                                  ),
                                                ),


                                                IconButton(
                                                    icon: Icon(
                                                      playerModel
                                                          .isPlaying
                                                          ? Icons
                                                          .pause
                                                          : Icons
                                                          .play_arrow,
                                                      size: 32,
                                                      color: Colors
                                                          .white,
                                                    ),
                                                    onPressed: () {
                                                      playerProv
                                                          .togglePlayPause(
                                                          playerModel
                                                              .isPlaying);
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
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
