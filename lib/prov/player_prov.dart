
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider_plus/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/player/player.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/handler/audio_back_state_handler.dart';
import 'package:skrrskrr/prov/track_prov.dart';

class PlayerProv extends ChangeNotifier {

  AudioHandler? mediaPlaybackHandler = null;
  final AudioPlayer _audioPlayer = AudioPlayer();
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);
  PlayerModel playerModel = PlayerModel();
  ValueNotifier<bool> audioPlayerNotifier = ValueNotifier<bool>(false);
  late CarouselSliderController carouselSliderController = CarouselSliderController();
  Completer<void>? currentRequest;
  StreamSubscription? positionSubscription;
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

  Future<void> initAudioPlayer(
      TrackProv trackProv,
      Function initAudioPlayerTrackListCallBack,
      trackItemIdx) async {

    await initAudioPlayerTrackListCallBack();
    await initAudio(trackProv, trackItemIdx);
  }

  Future<void> setupQueue(List<Track> audioTrackPlayList, int priorityIndex) async {

    if (currentRequest != null && !currentRequest!.isCompleted) {
      currentRequest!.complete();
      currentRequest = null;
    }

    currentRequest = Completer<void>();

    _playlist.clear();

    List<AudioSource> allTracks = List.generate(audioTrackPlayList.length, (index) =>
        AudioSource.uri(Uri.parse(dotenv.get("STREAM_URL") + '/${audioTrackPlayList[priorityIndex].trackId}/playList.m3u8'))
    );

    _playlist = ConcatenatingAudioSource(children: allTracks);

    await _audioPlayer.setAudioSource(_playlist, preload: true, );
    await _audioPlayer.seek(Duration.zero, index: priorityIndex);

    List<Future<AudioSource>> futureTracks = [];

    for (int i = 0; i < audioTrackPlayList.length; i++) {
      if (i != priorityIndex) {
        String m3u8Url = dotenv.get("STREAM_URL") + '/${audioTrackPlayList[i].trackId}/playList.m3u8';
        futureTracks.add(Future(() async {
          return AudioSource.uri(Uri.parse(m3u8Url));
        }));
      }
    }

    int trackIndex = 0;

    await Future.any([
      Future.wait(futureTracks).then((sources) async {
        for (int i = 0; i < audioTrackPlayList.length; i++) {
          if (i != priorityIndex) {
            print("백그라운드 작업 인덱스 : $i");
            await _playlist.removeAt(i);
            await _playlist.insert(i, sources[trackIndex]);
            trackIndex++;
          }
        }
        currentRequest!.complete();
        currentRequest = null;
      }),
      currentRequest?.future ?? Future.value()
    ]);
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

  Future<void> mediaPlaybackHandlerInit(TrackProv trackProv, Track track) async {

    mediaPlaybackHandler = await AudioService.init(
      builder: () => AudioBackStateHandler(this, trackProv ,track),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.skrrskrr.music.player',
        androidNotificationChannelName: 'SkrrSkrr Music Player',
        androidStopForegroundOnPause: false,
        androidShowNotificationBadge: true,
      )
    );

    await mediaPlaybackHandler!.play();
    await mediaPlaybackHandler!.pause();
  }

  Future<void> initAudio(TrackProv trackProv, int trackItemIdx) async {

    print("initAudio");

    _audioPlayer.stop();
    _audioPlayer.setLoopMode(LoopMode.off);
    _audioPlayer.setShuffleModeEnabled(false);
    audioPlayerClear();
    setupQueue(trackProv.audioPlayerTrackList,trackItemIdx);
  }

  void audioPlayerPositionUpdate() {
    
    playerModel.isBuffering = _audioPlayer.playbackEvent.processingState == ProcessingState.buffering;

    playerModel.currentPosition = Duration(seconds: (_audioPlayer.position.inMilliseconds / 1000).round());

    playerModel.totalDuration = _audioPlayer.playbackEvent.duration ?? Duration.zero;
  }

  Future<void> updateAudioPlayerSwiper(int trackId, TrackProv trackProv) async {

    int index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId == trackId);

    if (index != -1) {

      if (currentPage == index) {

        await AudioBackStateHandler(this, trackProv, trackProv.audioPlayerTrackList[index])
            .mediaItemUpdate(trackProv.audioPlayerTrackList[index]);

        await audioTrackMoveSetting(trackProv, index);

      } else {
        currentPage = index;
      }
      carouselSliderController.jumpToPage(index);
    }
  }

  Future<void> reloadDeleteTrack(TrackProv trackProv,Track trackItem, int trackItemIdx) async {

    int index = trackProv.audioPlayerTrackList.indexWhere((track) => track.trackId == trackItem.trackId);

    if (index == -1) {
      trackProv.audioPlayerTrackList.insert(trackItemIdx, trackItem);
      await addTrack(trackItem, trackItemIdx);
      trackProv.notify();
    }
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
        await _audioPlayer.seek(Duration.zero);
        await mediaPlaybackHandler?.seek(Duration.zero);

      } else if (index + 1 < trackProv.audioPlayerTrackList.length) {

        const platform = MethodChannel('device_lock_status');
        bool isLockScreen = await platform.invokeMethod('isDeviceLocked');

        if (isLockScreen) {
          carouselSliderController.jumpToPage(index + 1);
        } else {
          await carouselSliderController.animateToPage(index + 1, duration: Duration(milliseconds: 500));
        }

      } else {
        if (playerModel.audioPlayerPlayOption == 1) {
          currentPage = 0;
          carouselSliderController.jumpToPage(0);
        } else {
          playerModel.isPlaying = false;
          stopTimer();
          await _audioPlayer.pause();
        }
        await _audioPlayer.seek(Duration.zero);
        await mediaPlaybackHandler?.seek(Duration.zero);
      }
    }
  }

  void setTimer(TrackProv trackProv) async {

    if (positionSubscription == null) {

      int prevPosition = 0;

      positionSubscription?.cancel();
      positionSubscription = _audioPlayer.positionStream.listen((position) async {

        if (prevPosition != position.inSeconds) {
          audioPlayerPositionUpdate();
          if (playerModel.totalDuration.inSeconds != 0) {
            if (prevPosition + 1 == playerModel.totalDuration.inSeconds) {
              prevPosition = 0;
              await _audioPlayer.pause();
              await nextTrackLoad(trackProv);
            } else {
              notify();
            }
          }
          prevPosition = position.inSeconds;
        }
      });
    }
  }

  void stopTimer() {
    positionSubscription?.cancel();
    positionSubscription = null;
  }

  Future<void> handleAudioReset() async {
    audioPlayerClear();
    await _audioPlayer.pause();
    notify();
  }

  void pausePlay() {
    playerModel.isPlaying = false;
    stopTimer();
    _audioPlayer.pause();
    notify();
  }

  void resumePlay(TrackProv trackProv) {
    playerModel.isPlaying = true;
    setTimer(trackProv);
    _audioPlayer.play();
    notify();
  }

  Future<void> togglePlayPause(bool isPlaying, TrackProv trackProv) async {
    if (isPlaying) {
      await mediaPlaybackHandler?.pause();
    } else {
      await mediaPlaybackHandler?.play();
    }
  }

  // 드래그 중일 때 크기 조정
  void handleDragUpdate(DragUpdateDetails details) {
    playerModel.dragOffset += details.delta;
    if (playerModel.dragOffset.dy > 90) {
      playerModel.height = 80;

    } else if (playerModel.dragOffset.dy < 90) {
      playerModel.height = 100.h;
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

    playerModel.dragOffset = Offset.zero;
    notify();
    return playerModel.fullScreen;
  }

  // 슬라이더 터치가 끝났을 때 위치 조정
  Future<void> onSliderChangeEnd(double value, bool isPlayBackUpdate) async {

    await _audioPlayer.seek(Duration(seconds: value.toInt()));

    if (isPlayBackUpdate) {
      await mediaPlaybackHandler?.seek(Duration(seconds: value.toInt()));
    }
  }

  void setFullScreen() {
    playerModel.height = 100.h;
    playerModel.fullScreen = true;
    notify();
  }
}