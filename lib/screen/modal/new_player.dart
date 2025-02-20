import 'dart:async'; // Timer 관련 라이브러리 추가

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';

class HLSStreamPage extends StatefulWidget {
  const HLSStreamPage({
    super.key,
    required this.playerHeight,
    required this.isFullScreen,
    required this.isFullScreenFunc,
    required this.isPlayingFunc,
    required this.isPlaying,
  });

  final Function isFullScreenFunc;
  final Function isPlayingFunc;
  final bool isPlaying;
  final double playerHeight;
  final bool isFullScreen;

  @override
  _HLSStreamPageState createState() => _HLSStreamPageState();
}

class _HLSStreamPageState extends State<HLSStreamPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  late Timer _timer; // Timer 변수 추가
  Offset _dragOffset = Offset.zero;
  AudioPlayerManager audioPlayerManager = AudioPlayerManager();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // HLS 스트리밍 URL 설정
    _audioPlayer.setUrl('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');

    // 재생 상태 변경 리스너
    _audioPlayer.playbackEventStream.listen((event) {

      if(!mounted)
        return;

      // 처리 상태를 확인하여 버퍼링 상태를 표시
      _isBuffering = event.processingState == ProcessingState.buffering;

      // 현재 재생 위치 업데이트
      _currentPosition = _audioPlayer.position;

      // 총 재생 시간 업데이트
      _totalDuration = event.duration ?? Duration.zero;

      setState(() {});
    });

    // 1초마다 setState를 호출하여 Slider를 업데이트
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return; // 위젯이 여전히 트리에 있는지 확인

      // 매초마다 현재 위치를 갱신
      _currentPosition = _audioPlayer.position;
      setState(() {});
    });
  }

  // 재생/일시정지 버튼
  void _togglePlayPause() async {
    if (_isPlaying) {
      _isPlaying = false;
      await _audioPlayer.pause();
    } else {
      _isPlaying = true;
      await _audioPlayer.play();
    }
    setState(() {});
  }


  // 슬라이더 터치가 끝났을 때 위치 조정
  void _onSliderChangeEnd(double value) {
    final newPosition = Duration(seconds: value.toInt());
    _audioPlayer.seek(newPosition);
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();  // 오디오 플레이어 해제
    _timer.cancel(); // 타이머 해제
  }

  @override
  Widget build(BuildContext context) {
    double _height = widget.playerHeight; // 초기 크기

    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          // 드래그 방향에 따라 크기 조정
          _dragOffset += details.delta;
          // 드래그 방향에 따라 플레이어 크기 변경
          if (_dragOffset.dy > 0) {
            // 아래로 드래그 (플레이어 커지기)
            _height = 80; // 작은 플레이어 크기
          } else if (_dragOffset.dy < 0) {
            // 위로 드래그 (플레이어 작아지기)
            _height = 100.h; // 전체 화면 크기
          }
          setState(() {});
        },
        onPanEnd: (details) {
          // 드래그 종료 후 크기 고정
          if (_height == 80) {
            audioPlayerManager.model.fullScreen = false;
            widget.isFullScreenFunc(false);
          } else {
            audioPlayerManager.model.fullScreen = true;
            widget.isFullScreenFunc(true);
          }

          // 드래그 후 위치 초기화
          _dragOffset = Offset.zero;
          setState(() {});
        },
        onTap: () {
          _height = 100.h; // 화면 전체 크기 확장
          audioPlayerManager.model.fullScreen = true;
          setState(() {
          });
          widget.isFullScreenFunc(true);
        },
        child: widget.isFullScreen
            ?  Container(
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
              bool isCollapsed = constraints.maxHeight < 100; // 기준 높이 설정

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
                              audioPlayerManager.model.fullScreen = false;
                              widget.isFullScreenFunc(false);
                              _height = 80;
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
                                            audioPlayerManager.model.fullScreen = false;
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
                                        value: _currentPosition.inSeconds.toDouble(),
                                        min: 0.0,
                                        max: _totalDuration.inSeconds.toDouble(),
                                        onChanged: _isBuffering
                                            ? null
                                            : (value) {
                                          _currentPosition = Duration(seconds: value.toInt());
                                          setState(() {});
                                        },
                                        onChangeEnd: _isBuffering ? null : _onSliderChangeEnd,
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
                                              '${_currentPosition.toString().split('.').first}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors
                                                      .white),
                                            ),
                                            Text(
                                              '${_totalDuration.toString().split('.').first}',
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
                                    _isBuffering
                                        ? CircularProgressIndicator()
                                        : IconButton(
                                      icon: Icon(
                                        _isPlaying ? Icons.pause : Icons.play_arrow,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      onPressed: _togglePlayPause,
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
        )

            :  Container(
              color: Colors.black.withOpacity(1),
              child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          child: IconButton(
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 32,
                              color: Colors.white,
                            ),
                            onPressed: _togglePlayPause,
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
            ),

      ),
    );
  }
}
