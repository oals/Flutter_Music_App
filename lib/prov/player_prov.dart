
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
  String? currentAppScreen = "";
  int currentPage = 0;

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

  Future<void> initAudioPlayer(TrackProv trackProv,int trackId , String appScreenName, Function initAudioPlayerTrackListCallBack) async{
    if (currentAppScreen != appScreenName) {
      currentAppScreen = appScreenName;
      await initAudioPlayerTrackListCallBack();
      await initAudio(trackProv);
    }
  }

  Future<void> setupQueue(List<Track> audioTrackPlayList) async {

    _playlist.clear();

    for (Track track in audioTrackPlayList) {
      String m3u8Url = dotenv.get("STREAM_URL") + '/${track.trackId}/playList.m3u8';
      final source = AudioSource.uri(Uri.parse(m3u8Url));
      _playlist.add(source);
    }

    await _audioPlayer.setAudioSource(_playlist,preload: true); // 큐를 오디오 플레이어에 설정
  }

  Future<void> addTrack(Track newTrack,int index) async {
    String m3u8Url = dotenv.get("STREAM_URL") + '/${newTrack.trackId}/playList.m3u8';

    final newSource = AudioSource.uri(Uri.parse(m3u8Url));

    await _playlist.insert(index,newSource);

    await _audioPlayer.load();
  }

  Future<void> playTrackAtIndex(int index) async {

    if (index >= 0 && index <= ( _playlist.length - 1) ) {
      await _audioPlayer.seek(Duration.zero, index: index);
      if (playerModel.isPlaying) {
        await _audioPlayer.play();
      }
    }
  }

  Future<void> removeTrack(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _playlist.removeAt(index);
    } else {
      print("오디오 플레이리스트 트랙 제거 중 오류");
    }
  }

  Future<void> initAudio(TrackProv trackProv) async {

    print("initAudio");

    await setupQueue(trackProv.audioPlayerTrackList);

    _audioPlayer.setLoopMode(LoopMode.off);
    _audioPlayer.setShuffleModeEnabled(false);

    audioPlayerPositionUpdate();
  }

  void audioPlayerPositionUpdate() {
    
    playerModel.isBuffering = _audioPlayer.playbackEvent.processingState == ProcessingState.buffering;

    // 현재 재생 위치 업데이트
    playerModel.currentPosition = Duration(seconds: (_audioPlayer.position.inMilliseconds / 1000).round());

    // 총 재생 시간 업데이트
    playerModel.totalDuration = _audioPlayer.playbackEvent.duration ?? Duration.zero;

  }

  Future<void> audioTrackMoveSetting(TrackProv trackProv, int index) async{

    audioPlayerClear();

    togglePlayPause(!playerModel.isPlaying,trackProv);

    if (trackProv.audioPlayerTrackList.length > currentPage) {
      trackProv.audioPlayerTrackList[currentPage].isPlaying = false;
    }

    trackProv.audioPlayerTrackList[index].isPlaying = true;

    currentPage = index;

    await playTrackAtIndex(currentPage);

    if (trackProv.lastListenTrackList[0].trackId != trackProv.audioPlayerTrackList[index].trackId!) {
      trackProv.updateLastListenTrackList(trackProv.audioPlayerTrackList[index]);
    }

    await trackProv.setLastListenTrackId(trackProv.audioPlayerTrackList[index].trackId!);
    trackProv.notify();
  }


  Future<void> nextTrackLoad(TrackProv trackProv) async {
    int index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId.toString() == trackProv.lastTrackId);

    if (index != -1) {
      trackProv.setTrackPlayCnt(trackProv.audioPlayerTrackList[index].trackId!);

      if (playerModel.audioPlayerPlayOption == 2) {
        playerModel.currentPosition = Duration.zero;
        await _audioPlayer.seek(Duration.zero);
      } else if (index + 1 < trackProv.audioPlayerTrackList.length) {
        await swiperController.move(index + 1, animation: true);
      } else {

        if (playerModel.audioPlayerPlayOption == 1) {


          print('처음부터시작');
          await audioTrackMoveSetting(trackProv,0);
          // await swiperController.next(animation: true);



        } else {
          playerModel.isPlaying = false;
          stopTimer();
          await _audioPlayer.pause();
        }

        playerModel.currentPosition = Duration.zero;
        await _audioPlayer.seek(Duration.zero);

      }
    }
  }


  void setTimer(TrackProv trackProv) async {

    if (playerModel.timer == null) {
      audioPlayerPositionUpdate();

      playerModel.timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        audioPlayerPositionUpdate();

        if (playerModel.currentPosition.inSeconds == playerModel.totalDuration.inSeconds) {
          await nextTrackLoad(trackProv);
        } else {
          notify();
        }
      });
    }
  }

  void stopTimer() {
    playerModel.timer?.cancel();
    playerModel.timer = null;
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