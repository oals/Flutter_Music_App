import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:skrrskrr/model/player/player.dart';

class AudioPlayerManager extends ChangeNotifier {
  Player model = Player();
  final AudioPlayer audioPlayer = AudioPlayer();
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> positionNotifier = ValueNotifier<Duration>(Duration.zero);
  Duration duration = Duration.zero;

  Timer? _amplitudeTimer; // 타이머 변수 추가

  // 진폭 값
  double _currentAmplitude = 0.0;

  AudioPlayerManager() {
    audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      positionNotifier.value = newPosition;
    });
  }


  void audioPlay(String audioPath) async {
    await audioPlayer.play(AssetSource(audioPath));
    _startAmplitudeSimulation();
    isPlayingNotifier.value = true;
  }
  void audioStop() async {
    await audioPlayer.pause();
    isPlayingNotifier.value = false;
  }


  void seekAudio(Duration newPosition) {
    audioPlayer.seek(newPosition);
  }

  // 현재 진폭 반환 메서드
  double getCurrentAmplitude() {
    return _currentAmplitude;
  }

  // 진폭 시뮬레이션
  void _startAmplitudeSimulation() {
    _amplitudeTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!isPlayingNotifier.value) {
        timer.cancel();
        return;
      }

      // 진폭 값을 랜덤으로 변경
      _currentAmplitude = (0.5 + (0.5 * (0.5 - Random().nextDouble()))).clamp(0.0, 1.0);
      notifyListeners(); // 상태 변경 알림
    });
  }

  @override
  void dispose() {
    _amplitudeTimer?.cancel(); // 타이머 취소
    audioPlayer.dispose();
    isPlayingNotifier.dispose();
    positionNotifier.dispose();
    super.dispose();
  }
}
