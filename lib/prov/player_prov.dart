
import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/player/player.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/modal/new_player.dart';

class PlayerProv extends ChangeNotifier {

  final AudioPlayer _audioPlayer = AudioPlayer();
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  PlayerModel playerModel = PlayerModel();

  ValueNotifier<bool> audioPlayerNotifier = ValueNotifier<bool>(false);
  late SwiperController swiperController;

  int currentPage = 0;
  int page = -1;


  void notify() {
    notifyListeners();
  }

  void clear() {
    playerModel = PlayerModel();
  }

  void audioPlayerClear() {
    playerModel.isBuffering = false;
    playerModel.currentPosition = Duration.zero;
    playerModel.totalDuration = Duration.zero;
    playerModel.dragOffset = Offset.zero;
  }


  Future<void> setupQueue(List<Track> audioTrackPlayList) async {

    _playlist.clear();

    for (Track track in audioTrackPlayList) {
      String m3u8Url = dotenv.get("STREAM_URL") + '/${track.trackId}/playList.m3u8';
      final source = AudioSource.uri(Uri.parse(m3u8Url));
      _playlist.add(source); // 큐에 추가
    }

    await _audioPlayer.setAudioSource(_playlist); // 큐를 오디오 플레이어에 설정
  }


  Future<void> playTrackAtIndex(int index) async {
    if (index >= 0 && index < _playlist.length) {
      await _audioPlayer.seek(Duration.zero, index: index);
      if (playerModel.isPlaying) {
        await _audioPlayer.play();
      }
    } else {
      print("잘못된 인덱스.");
    }
  }

  Future<void> removeTrack(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _playlist.removeAt(index); // 특정 인덱스의 트랙 제거
    } else {
      print("오디오 플레이리스트 트랙 제거 중 오류");
    }
  }

  Future<void> initAudio(TrackProv trackProv, int trackId) async {
    print("initAudio");
    await setupQueue(trackProv.audioPlayerTrackList);
    _audioPlayer.setLoopMode(LoopMode.off);

    audioPlayerPositionUpdate();
  }

  void audioPlayerPositionUpdate() {
    
    playerModel.isBuffering = _audioPlayer.playbackEvent.processingState == ProcessingState.buffering;

    // 현재 재생 위치 업데이트
    playerModel.currentPosition = _audioPlayer.position;

    // 총 재생 시간 업데이트
    playerModel.totalDuration = _audioPlayer.playbackEvent.duration ?? Duration.zero;

  }


  void setTimer(TrackProv trackProv) async {

    if(playerModel.timer == null) {
      playerModel.timer = Timer.periodic(Duration(seconds: 1), (timer) async {

        audioPlayerPositionUpdate();

        if (playerModel.currentPosition.inSeconds == playerModel.totalDuration.inSeconds - 1) {

          if (page == -1 ) {
            page = currentPage + 1;
          } else {
            currentPage = page;
            page = page + 1;
          }

          swiperController.move(page, animation: true);
          await playTrackAtIndex(page);
        }

        notify();

      });
    }

  }

  void stopTimer() {
    playerModel.timer?.cancel(); // 타이머 취소
    playerModel.timer = null;    // 타이머 변수 초기화
  }

  // 재생/일시정지 버튼
  void togglePlayPause(bool isPlaying, TrackProv trackProv) async {
    if (isPlaying) {
      playerModel.isPlaying = false;
      stopTimer();
      await _audioPlayer.pause();
    } else {
      playerModel.isPlaying = true;
      setTimer(trackProv);
      await _audioPlayer.play();
    }
    notify();
  }



  // 드래그 중일 때 크기 조정
  void handleDragUpdate(DragUpdateDetails details) {
    playerModel.dragOffset += details.delta;
    if (playerModel.dragOffset.dy > 90) {
      playerModel.height = 80; // 작은 플레이어 크기

    } else if (playerModel.dragOffset.dy < 90) {
      playerModel.height = 100.h; // 전체 화면 크기
    }
    notify();
  }

// 드래그가 끝났을 때 처리
  bool handleDragEnd() {
    if (playerModel.height == 80) {
      playerModel.fullScreen = false;
    } else {
      playerModel.fullScreen = true;
    }

    // 드래그 후 위치 초기화
    playerModel.dragOffset = Offset.zero;
    notify();
    return playerModel.fullScreen;
  }


  // 슬라이더 터치가 끝났을 때 위치 조정
  void onSliderChangeEnd(double value) {
    final newPosition = Duration(seconds: value.toInt());
    _audioPlayer.seek(newPosition);
    notify();
  }

  void setFullScreen() {
    playerModel.height = 100.h; // 화면 전체 크기 확장
    playerModel.fullScreen = true;
    notify();
  }


}
