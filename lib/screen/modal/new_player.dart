import 'dart:async'; // Timer 관련 라이브러리 추가
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
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/utils/helpers.dart';


class HLSStreamPage extends StatefulWidget {
  const HLSStreamPage({
    super.key,
  });


  @override
  _HLSStreamPageState createState() => _HLSStreamPageState();
}

class _HLSStreamPageState extends State<HLSStreamPage>  {
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
                child: Container(
                    color: Colors.black,
                    child: Column(
                        children: [
                          if(appProv.isFullScreen)
                            Container(
                              height: 100.h, // 화면 높이에 맞게 조정
                                  decoration: BoxDecoration(
                                    color: Color(0xff000000),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      bool isCollapsed = constraints.maxHeight < 100; // 기준 높이 설정

                                      return SingleChildScrollView( // 화면 크기에 맞게 스크롤 가능하게
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            if (!isCollapsed) ...[
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(context).size.width, // 화면 너비에 맞게 조정
                                                    height: 100.h, // 이미지 높이를 적절히 조정
                                                    child: Stack(
                                                      children: [
                                                        CustomCachedNetworkImage(
                                                            imagePath: trackInfoMdoel.trackImagePath,
                                                            imageWidth: null,
                                                            imageHeight: 85.h
                                                        ),


                                                        Container(
                                                          width: double.infinity, // 이미지와 동일한 너비로 설정
                                                          height: 85.h,
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
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top : 40,
                                                    right : 10,
                                                    child: GestureDetector(
                                                      onTap:(){
                                                        playerProv.playerModel.fullScreen = false;
                                                        appProv.isFullScreenFunc(false);
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.only(right: 10),
                                                        child: Container(
                                                            width: 30,
                                                            height : 30,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(100),
                                                              color: Colors.grey,
                                                            ),
                                                            child: Icon(
                                                              Icons.keyboard_arrow_down_sharp,color: Colors.white,)
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Positioned(
                                                    top: 75.h, // 전체 화면 높이에 비례한 위치 지정
                                                    left : 0,
                                                    right : 0,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                                    },
                                                                    child: Text(
                                                                      trackInfoMdoel.trackNm ?? "잠시 후 다시 시도해주세요.",
                                                                      style: TextStyle(
                                                                        fontSize: 23,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
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
                                                                        fontSize: 17,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.grey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        ValueListenableBuilder<Duration>(
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

                                                        Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 30,
                                                                backgroundColor: Color(0xff1c1c1c),
                                                                child: SvgPicture.asset(
                                                                  'assets/images/backward_left.svg',
                                                                  width: 15,
                                                                  height: 15,
                                                                ),
                                                              ),
                                                              CircleAvatar(
                                                                radius: 30,
                                                                backgroundColor: Color(0xff1c1c1c),
                                                                child: SvgPicture.asset(
                                                                  'assets/images/rewind_15_left.svg',
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                              playerModel.isBuffering
                                                                  ? CircularProgressIndicator()
                                                                  : IconButton(
                                                                icon: Icon(
                                                                  playerModel.isPlaying ? Icons.pause : Icons.play_arrow,
                                                                  size: 48,
                                                                  color: Colors.grey,
                                                                ),
                                                                onPressed: playerProv.togglePlayPause,
                                                              ),
                                                              CircleAvatar(
                                                                radius: 30,
                                                                backgroundColor: Color(0xff1c1c1c),
                                                                child: SvgPicture.asset(
                                                                  'assets/images/rewind_15_right.svg',
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                              CircleAvatar(
                                                                radius: 30,
                                                                backgroundColor: Color(0xff1c1c1c),
                                                                child: SvgPicture.asset(
                                                                  'assets/images/backward_right.svg',
                                                                  width: 15,
                                                                  height: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ]
                                          ],
                                        ),
                                      );
                                    },
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
                                          Text(
                                            trackInfoMdoel.trackNm ?? "null",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            trackInfoMdoel.memberNickName ?? "null",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 30),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/backward_left.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(width: 15,),
                                        if (!playerProv.playerModel.fullScreen)
                                          Container(
                                            child: IconButton(
                                                icon: Icon(
                                                  playerModel.isPlaying ? Icons.pause : Icons.play_arrow,
                                                  size: 32,
                                                  color: Colors.white,
                                                ),
                                                onPressed: playerProv.togglePlayPause
                                            ),
                                          ),
                                        SizedBox(width: 15,),
                                        SvgPicture.asset(
                                          'assets/images/backward_right.svg',
                                          width: 20,
                                          height: 20,
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

                );
              }
            );
        }
      ),
    );
  }
}
