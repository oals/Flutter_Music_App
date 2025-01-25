import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/player_prov.dart';

import 'package:skrrskrr/screen/appScreen/track/music_info.dart';
import 'package:skrrskrr/screen/appScreen/comn/visualizer.dart';
import 'package:skrrskrr/utils/helpers.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.playerHeight,
    required this.isFullScreen,
    required this.isFullScreenFunc,
    required this.isPlayingFunc,
    required this.audioPath,
    required this.isPlaying,
    
  });

  final Function isFullScreenFunc;
  final Function isPlayingFunc;

  final bool isPlaying;
  final double playerHeight;
  final bool isFullScreen;
  final String audioPath;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  AudioPlayerManager audioPlayerManager = AudioPlayerManager();
  Timer? _visualizerTimer; // 타이머 변수를 추가
  double _amplitude = 0.5; // 비주얼라이저의 진폭 초기값

  @override
  void initState() {
    super.initState();
    audioPlayerManager.model.fullScreen = widget.isFullScreen;
    audioPlayerManager.isPlayingNotifier.value = widget.isPlaying;

    if (audioPlayerManager.isPlayingNotifier.value) {
      audioPlayerManager.audioPlay(widget.audioPath);
    }
    _startVisualizer();
  }

  @override
  void dispose() {
    audioPlayerManager.audioStop();
    _visualizerTimer?.cancel(); // 타이머 취소
    super.dispose();
  }

  void _startVisualizer() {
    _visualizerTimer = Timer.periodic(Duration(milliseconds: 11100), (timer) {
      if (!mounted) return; // 위젯이 여전히 트리에 있는지 확인

      setState(() {
        _amplitude = audioPlayerManager.getCurrentAmplitude(); // 실제 데이터로 교체
      });
    });
  }

  Offset _dragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {

    double _height = widget.playerHeight; // Initial height

    return GestureDetector(
      onPanUpdate: (details) {
          _dragOffset += details.delta;
      },
      onPanEnd: (details) {
        if (_dragOffset.dy.abs() > 90) {
          if (_dragOffset.dy > 0) {
            audioPlayerManager.model.fullScreen = false;
            widget.isFullScreenFunc(false);
            _height = 80;
          } else {
            audioPlayerManager.model.fullScreen = true;
            widget.isFullScreenFunc(true);
            _height = 150.h;
          }
        }
        // 드래그가 끝났을 때 초기화
        setState(() {
          _dragOffset = Offset.zero;
        });
      },
      onTap: () {
        setState(() {
          audioPlayerManager.model.fullScreen = true;
          _height = 100.h; // Increase height
        });
        widget.isFullScreenFunc(true);
      },
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 작은 플레이어
              if (_height <= 80)
                Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            // 원하는 둥글기 조정
                            child: Image.asset(
                              'assets/images/testImage.png',
                              width: 45,
                              height: 45,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'test',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'test123',
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
                            if (!audioPlayerManager.model.fullScreen)
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    audioPlayerManager.isPlayingNotifier.value =
                                        !audioPlayerManager.isPlayingNotifier.value;
                                    if (audioPlayerManager
                                        .isPlayingNotifier.value) {
                                      widget.isPlayingFunc(true);
                                      audioPlayerManager
                                          .audioPlay(widget.audioPath);
                                    } else {
                                      widget.isPlayingFunc(false);
                                      audioPlayerManager.audioStop();
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white, // 테두리 색상
                                        width: 3.0, // 테두리 두께
                                      ),
                                      shape: BoxShape.circle, // 원형으로 설정
                                    ),
                                    child: SvgPicture.asset(
                                      audioPlayerManager.isPlayingNotifier.value
                                          ? 'assets/images/pause_circle.svg'
                                          : 'assets/images/play_circle.svg',
                                      width: 4.5.w,
                                      height: 4.5.h,
                                    ),
                                  ),
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

              ///큰 플레이어
              if (_height > 80)

                Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff000000), // 상단의 연한 색
                        Color(0xff000000),    // 하단의 어두운 색
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isCollapsed = constraints.maxHeight < 200; // 기준 높이 설정

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [


                          if (!isCollapsed) ...[

                            Stack(
                              children: [

                                Container(
                                  height : 100.h,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        'assets/images/category_hiphop.jpg',
                                        width: 100.w,
                                        height: 85.h,
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        width: 100.w,
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
                                      setState(() {
                                        audioPlayerManager.model.fullScreen = false;
                                        widget.isFullScreenFunc(false);
                                        _height = 80;
                                      });
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
                                  top: 75.h,
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
                                                    audioPlayerManager.model.fullScreen =
                                                    false;
                                                    widget.isFullScreenFunc(false);
                                                    _height = 80;

                                                    // AppRouter.fnRouter(0);
                                                  },
                                                  child: const Text(
                                                    '종착역 (Feat. PH-1)',
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
                                                    audioPlayerManager.model.fullScreen =
                                                    false;
                                                    widget.isFullScreenFunc(false);
                                                    _height = 80;

                                                    GoRouter.of(context).push('/userPage/${await Helpers.getMemberId()}');
                                                  },
                                                  child: const Text(
                                                    '테이크원',
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
                                        audioPlayerManager.positionNotifier,
                                        builder: (context, position, child) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Slider(
                                                min: 0,
                                                max: audioPlayerManager.duration.inSeconds
                                                    .toDouble() ==
                                                    0
                                                    ? 1
                                                    : audioPlayerManager.duration.inSeconds
                                                    .toDouble(),
                                                value: position.inSeconds.toDouble(),
                                                onChanged: (value) {
                                                  audioPlayerManager.seekAudio(
                                                      Duration(seconds: value.toInt()));
                                                },
                                                activeColor: Colors.white,
                                                // Changed to white
                                                inactiveColor:
                                                Colors.white, // Changed to black
                                              ),
                                              Container(
                                                padding:
                                                EdgeInsets.only(left: 20, right: 30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${position.inMinutes}:${(position.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .white), // Changed to white
                                                    ),
                                                    Text(
                                                      '${audioPlayerManager.duration.inMinutes}:${(audioPlayerManager.duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .white), // Changed to white
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
                                              // Changed to black
                                              child: SvgPicture.asset(
                                                'assets/images/backward_left.svg',
                                                width: 15,
                                                height: 15,
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Color(0xff1c1c1c),
                                              // Changed to black
                                              child: SvgPicture.asset(
                                                'assets/images/rewind_15_left.svg',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            ValueListenableBuilder<bool>(
                                              valueListenable:
                                              audioPlayerManager.isPlayingNotifier,
                                              builder: (context, isPlaying, child) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    audioPlayerManager
                                                        .isPlayingNotifier.value =
                                                    !audioPlayerManager
                                                        .isPlayingNotifier.value;
                                                    if (audioPlayerManager
                                                        .isPlayingNotifier.value) {
                                                      widget.isPlayingFunc(true);
                                                      audioPlayerManager
                                                          .audioPlay(widget.audioPath);
                                                    } else {
                                                      widget.isPlayingFunc(false);
                                                      audioPlayerManager.audioStop();
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.white, // 테두리 색상
                                                        width: 3.0, // 테두리 두께
                                                      ),
                                                      shape: BoxShape.circle, // 원형으로 설정
                                                    ),
                                                    child: SvgPicture.asset(
                                                      audioPlayerManager
                                                          .isPlayingNotifier.value
                                                          ? 'assets/images/pause_circle.svg'
                                                          : 'assets/images/play_circle.svg',
                                                      width: 4.5.w,
                                                      height: 4.5.h,
                                                    ),
                                                  ),
                                                );
                                              },
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
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
