import 'dart:async'; // Timer 관련 라이브러리 추가
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/player/player.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/slider/circular_slider_track_shape.dart';
import 'package:skrrskrr/screen/subScreen/comn/slider/gradient_slider_track_shape.dart';
import 'package:skrrskrr/utils/helpers.dart';


class HLSStreamPage extends StatefulWidget {
  const HLSStreamPage({
    super.key,
  });


  @override
  _HLSStreamPageState createState() => _HLSStreamPageState();
}

class _HLSStreamPageState extends State<HLSStreamPage> {
  late PlayerProv playerProv;
  late TrackProv trackProv;
  late AppProv appProv;
  late PlayerModel playerModel;
  late Future<String> _getLastTrackInitFuture;
  late Future<bool> _getTrackInfoFuture;
  bool isLoading = false;




  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  // 비동기 메서드로 분리하여 await 사용
  Future<void> _initializePlayer() async {

    playerProv = Provider.of<PlayerProv>(context, listen: false);
    _getLastTrackInitFuture = Provider.of<TrackProv>(context, listen: false).getLastListenTrack();

    String lastTrackId = await playerProv.initLastTrack(_getLastTrackInitFuture);
    _getTrackInfoFuture = Provider.of<TrackProv>(context, listen: false).getPlayTrackInfo(lastTrackId);

    isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appProv.isPlayTrack) {
        playerProv.togglePlayPause();
      }
    });

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    appProv = Provider.of<AppProv>(context,listen: false);
    playerModel = playerProv.playerModel;
    trackProv = Provider.of<TrackProv>(context, listen: false);

    if(!isLoading){
      return CircularProgressIndicator();
    }

    // print('hlsStreamPage 빌드');


    return Scaffold(
      body: Consumer<PlayerProv>(
          builder: (context, PlayerProv, child) {
            return  FutureBuilder<bool>(
                future: _getTrackInfoFuture, // 비동기 메소드 호출
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('오류 발생: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('데이터가 없습니다.'));
                  }

                  Track trackInfoMdoel = trackProv.playTrackInfoModel;

                return GestureDetector(
                onPanUpdate: (details) {
                  playerProv.handleDragUpdate(details);

                },
                onPanEnd: (details) {
                  bool callBackValue = playerProv.handleDragEnd();
                  appProv.isFullScreenFunc(callBackValue);
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [

                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(40),
                                              child: CustomCachedNetworkImage(
                                                  imagePath: trackInfoMdoel.trackImagePath,
                                                  imageWidth: null,
                                                  imageHeight: 100.h,
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: playerProv.togglePlayPause,
                                              child: Container(
                                                width: 100.w,
                                                height: 90.h,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(0.9), // 하단은 어두운 색
                                                      Colors.transparent, // 상단은 투명
                                                    ],
                                                    stops: [0, 0.0],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            if(!playerModel.isPlaying)
                                              GestureDetector(
                                                onTap: playerProv.togglePlayPause,
                                                child: Container(
                                                  width: 100.w, // 이미지와 동일한 너비로 설정
                                                  height: 100.h,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.bottomCenter,
                                                      end: Alignment.topCenter,
                                                      colors: [
                                                        Colors.transparent.withOpacity(0.5), // 하단은 어두운 색
                                                        Colors.transparent, // 상단은 투명
                                                      ],
                                                      stops: [1, 1],
                                                    ),
                                                  ),
                                                ),
                                              ),


                                            Positioned(
                                              top : 12.h,
                                              right : 2.w,
                                              left: 0.w,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 15),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            print('해당 곡 정보 페이지로 이동');

                                                            playerProv.playerModel.fullScreen = false;
                                                            appProv.isFullScreenFunc(false);
                                                            GoRouter.of(context).push('/musicInfo/${trackInfoMdoel.trackId}');

                                                          },
                                                          child: SizedBox(
                                                            width: 70.w,
                                                            child: Text(
                                                              trackInfoMdoel.trackNm ?? "잠시 후 다시 시도해주세요.",
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.white,
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            print('해당 유저 페이지로 이동');
                                                            playerProv.playerModel.fullScreen = false;
                                                            appProv.isFullScreenFunc(false);

                                                            GoRouter.of(context).push('/userPage/${trackInfoMdoel.memberId}');
                                                          },
                                                          child: Text(
                                                            trackInfoMdoel.memberNickName ?? "잠시 후 다시 시도해주세요." ,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  GestureDetector(
                                                    onTap:(){
                                                      playerProv.playerModel.fullScreen = false;
                                                      appProv.isFullScreenFunc(false);
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                        width: 30,
                                                        height : 30,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: Colors.black,
                                                        ),
                                                        child: Icon(
                                                          Icons.keyboard_arrow_down_sharp,color: Colors.white,
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Positioned (
                                              top: 85.h, // 전체 화면 높이에 비례한 위치 지정
                                              left : 0,
                                              right : 0,
                                              child: ValueListenableBuilder<Duration>(
                                                valueListenable:
                                                playerModel.positionNotifier,
                                                builder: (context, position, child) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Slider(
                                                        value: playerModel.currentPosition.inSeconds.toDouble(),
                                                        min: 0.0,
                                                        max: playerModel.totalDuration.inSeconds.toDouble(),
                                                        onChanged: playerModel.isBuffering
                                                            ? null
                                                            : (value) {
                                                          playerModel.currentPosition = Duration(seconds: value.toInt());
                                                          setState(() {});
                                                        },
                                                        onChangeEnd: playerModel.isBuffering ? null : playerProv.onSliderChangeEnd,
                                                        activeColor: Colors.white,
                                                        inactiveColor: Colors.grey,
                                                      ),

                                                      Container(
                                                        padding:
                                                        EdgeInsets.only(left: 20, right: 30),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${playerModel.currentPosition.toString().split('.').first}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Text(
                                                              '${playerModel.totalDuration.toString().split('.').first}',
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
                                              ),
                                            ),
                                            Positioned(
                                              top : 47.h,
                                              left : 40.w,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    playerModel.isBuffering
                                                        ? CircularProgressIndicator()
                                                        : IconButton(
                                                      icon: Icon(
                                                        !playerModel.isPlaying ? Icons.pause : null,
                                                        size: 48,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: playerProv.togglePlayPause,
                                                    ),


                                                  ],
                                                ),
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
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff000000), // 상단의 연한 색 (색상값을 조정하세요)
                                      Color(0xff1c1c1c), // 하단의 어두운 색 (현재 색상)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                width: 100.w,
                                padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          // 원하는 둥글기 조정
                                          child:   CustomCachedNetworkImage(
                                            imagePath: trackInfoMdoel.trackImagePath,
                                            imageWidth: 14.w,
                                            imageHeight: 14.h,
                                          ),

                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            SizedBox(
                                              width: 60.w,
                                              child: Text(
                                                trackInfoMdoel.trackNm ?? "null.",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),

                                            Text(
                                              trackInfoMdoel.memberNickName ?? "null",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
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
                                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                                                      trackShape: CircularSliderTrackShape(
                                                        progress: playerModel.totalDuration.inSeconds > 0
                                                            ? playerModel.currentPosition.inSeconds / playerModel.totalDuration.inSeconds
                                                            : 0.0, // 진행 비율 계산
                                                    ),

                                                      trackHeight: 3.5, // 트랙의 두께
                                                    ),
                                                    child: Slider(
                                                      value: playerModel.currentPosition.inSeconds.toDouble(),
                                                      min: 0.0,
                                                      max: playerModel.totalDuration.inSeconds.toDouble(),
                                                      onChanged: null,
                                                      onChangeEnd: null,
                                                      activeColor: Colors.white,
                                                      inactiveColor: Colors.grey,
                                                    ),
                                                  ),
                                                ),


                                                IconButton(
                                                    icon: Icon(
                                                      playerModel.isPlaying ? Icons.pause : Icons.play_arrow,
                                                      size: 32,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: playerProv.togglePlayPause
                                                ),
                                              ],
                                            ),

                                        ],
                                      ),
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
            );
        }
      ),
    );
  }
}



