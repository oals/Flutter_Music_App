
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/player/player.dart';

class PlayerProv extends ChangeNotifier {
  PlayerModel playerModel = PlayerModel();
  late AudioPlayer _audioPlayer;

  void notify() {
    notifyListeners();
  }

  // Future를 비동기적으로 처리하기 위한 메소드
  Future<String> initLastTrack(Future<String> _getLastTrackInitFuture) async {
    String lastTrackId = await _getLastTrackInitFuture; // 결과를 기다립니다
    await initAudio(lastTrackId); // 작업 완료 후 audioInit 호출
    return lastTrackId;
  }

  Future<void> initAudio(String trackId) async {
    _audioPlayer = AudioPlayer();

    String m3u8Url = dotenv.get("STREAM_URL") + '/${trackId}/playList.m3u8';

    // AudioSource로 HLS URL 전달
    final source = AudioSource.uri(Uri.parse(m3u8Url));

    await _audioPlayer.setAudioSource(source);
    // 재생 상태 변경 리스너
    _audioPlayer.playbackEventStream.listen((event) {

      // if(!playerModel.mounted)
      //   return;

      // 처리 상태를 확인하여 버퍼링 상태를 표시
      playerModel.isBuffering = event.processingState == ProcessingState.buffering;

      // 현재 재생 위치 업데이트
      playerModel.currentPosition = _audioPlayer.position;

      // 총 재생 시간 업데이트
      playerModel.totalDuration = event.duration ?? Duration.zero;
      notify();
    });

    // setTimer();

  }

  void setTimer() async {
    // 1초마다 setState를 호출하여 Slider를 업데이트
    playerModel.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // if (!playerModel.mounted)
      //   return; // 위젯이 여전히 트리에 있는지 확인

      // 매초마다 현재 위치를 갱신
      playerModel.currentPosition = _audioPlayer.position;
      notify();
    });
  }

  // 재생/일시정지 버튼
  void togglePlayPause() async {
    if (playerModel.isPlaying) {
      playerModel.isPlaying = false;
      await _audioPlayer.pause();
    } else {
      playerModel.isPlaying = true;
      await _audioPlayer.play();
    }
    notify();
  }


  // 드래그 중일 때 크기 조정
  void handleDragUpdate(DragUpdateDetails details) {
    playerModel.dragOffset += details.delta;
    if (playerModel.dragOffset.dy > 0) {
      // 아래로 드래그 (플레이어 커지기)
      playerModel.height = 80; // 작은 플레이어 크기
    } else if (playerModel.dragOffset.dy < 0) {
      // 위로 드래그 (플레이어 작아지기)
      playerModel.height = 100.h; // 전체 화면 크기
    }
    notify();
  }

// 드래그가 끝났을 때 처리
  bool handleDragEnd(DragEndDetails details) {
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
