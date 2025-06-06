import 'dart:async';
import 'package:audio_service/audio_service.dart';
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

  PlayerModel playerModel = PlayerModel();
  bool isInitMediaPlaybackHandler = false;

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

    if (playerModel.currentRequest != null && !playerModel.currentRequest!.isCompleted) {
      playerModel.currentRequest!.complete();
      playerModel.currentRequest = null;
    }

    playerModel.currentRequest = Completer<void>();

    playerModel.playlist.clear();

    List<AudioSource> allTracks = List.generate(audioTrackPlayList.length, (index) =>
        AudioSource.uri(Uri.parse(audioTrackPlayList[priorityIndex].trackPath.toString()))
    );

    playerModel.playlist = ConcatenatingAudioSource(children: allTracks);

    await playerModel.audioPlayer.setAudioSource(playerModel.playlist, preload: true, );
    await playerModel.audioPlayer.seek(Duration.zero, index: priorityIndex);

    List<Future<AudioSource>> futureTracks = [];

    for (int i = 0; i < audioTrackPlayList.length; i++) {
      if (i != priorityIndex) {
        futureTracks.add(Future(() async {
          return AudioSource.uri(Uri.parse(audioTrackPlayList[i].trackPath.toString()));
        }));
      }
    }

    int trackIndex = 0;

    await Future.any([
      Future.wait(futureTracks).then((sources) async {
        for (int i = 0; i < audioTrackPlayList.length; i++) {
          if (i != priorityIndex) {
            print("백그라운드 작업 인덱스 : $i");
            await playerModel.playlist.removeAt(i);
            await playerModel.playlist.insert(i, sources[trackIndex]);
            trackIndex++;
          }
        }
        playerModel.currentRequest!.complete();
        playerModel.currentRequest = null;
      }),
      playerModel.currentRequest?.future ?? Future.value()
    ]);
  }

  Future<void> addTrack(Track newTrack,int index) async {

    final newSource = AudioSource.uri(Uri.parse(newTrack.trackPath.toString()));

    await playerModel.playlist.insert(index,newSource);

    await playerModel.audioPlayer.load();
  }

  Future<void> playTrackAtIndex(int index) async {

    if (index >= 0 && index <= ( playerModel.playlist.length - 1) ) {
      await playerModel.audioPlayer.seek(Duration.zero, index: index);
      if (playerModel.isPlaying) {
        playerModel.audioPlayer.play();
      }
    }
  }

  Future<void> removeTrack(int index) async {
    if (index >= 0 && index < playerModel.playlist.length) {
      playerModel.playlist.removeAt(index);
    } else {
      print("오디오 플레이리스트 트랙 제거 중 오류");
    }
  }

  Future<void> mediaPlaybackHandlerInit(TrackProv trackProv, Track track, bool isInitMediaPlaybackHandler) async {

    if (!isInitMediaPlaybackHandler) {
      playerModel.mediaPlaybackHandler = await AudioService.init(
          builder: () => AudioBackStateHandler(this, trackProv ,track),
          config: AudioServiceConfig(
            androidNotificationChannelId: 'com.skrrskrr.music.player',
            androidNotificationChannelName: 'SkrrSkrr Music Player',
            androidNotificationOngoing: true,
            androidStopForegroundOnPause: true,
            androidShowNotificationBadge: true,
          )
      );
    } else {
      playerModel.mediaPlaybackHandler = await AudioBackStateHandler.instance;
      await AudioBackStateHandler.instance?.mediaItemUpdate(track);
    }

    await playerModel.mediaPlaybackHandler!.play();
    await playerModel.mediaPlaybackHandler!.pause();
  }

  Future<void> initAudio(TrackProv trackProv, int trackItemIdx) async {

    print("initAudio");

    playerModel.audioPlayer.stop();
    playerModel.audioPlayer.setLoopMode(LoopMode.off);
    playerModel.audioPlayer.setShuffleModeEnabled(false);
    audioPlayerClear();
    setupQueue(trackProv.audioPlayerTrackList,trackItemIdx);
  }

  void audioPlayerPositionUpdate() {
    
    playerModel.isBuffering = playerModel.audioPlayer.playbackEvent.processingState == ProcessingState.buffering;

    playerModel.currentPosition = Duration(seconds: (playerModel.audioPlayer.position.inMilliseconds / 1000).round());

    playerModel.totalDuration = playerModel.audioPlayer.playbackEvent.duration ?? Duration.zero;
  }

  Future<void> updateAudioPlayerSwiper(int trackId, TrackProv trackProv) async {

    int index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId == trackId);

    if (index != -1) {

      await AudioBackStateHandler(this, trackProv, trackProv.audioPlayerTrackList[index])
          .mediaItemUpdate(trackProv.audioPlayerTrackList[index]);

      await audioTrackMoveSetting(trackProv, index);

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

    if (trackProv.audioPlayerTrackList.length > playerModel.currentPage) {
      trackProv.audioPlayerTrackList[playerModel.currentPage].isPlaying = false;
    }

    trackProv.audioPlayerTrackList[index].isPlaying = true;

    playerModel.currentPage = index;
    await playTrackAtIndex(playerModel.currentPage);

    if (trackProv.lastListenTrackList.isNotEmpty) {
      if (trackProv.lastListenTrackList[0].trackId != trackProv.audioPlayerTrackList[index].trackId!) {
        trackProv.updateLastListenTrackList(trackProv.audioPlayerTrackList[index]);
      }
    } else {
      trackProv.lastListenTrackList.insert(0, trackProv.audioPlayerTrackList[index]);
      trackProv.lastListenTrackList[0].isPlaying = true;
    }

    await trackProv.setLastListenTrackId(trackProv.audioPlayerTrackList[index].trackId!);
    trackProv.notify();
  }

  Future<void> nextTrackLoad(TrackProv trackProv) async {
    int index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId.toString() == trackProv.lastTrackId);

    if (index != -1) {

      trackProv.setTrackPlayCnt(trackProv.audioPlayerTrackList[index].trackId!);

      if (playerModel.audioPlayerPlayOption == 2) {
        await playerModel.audioPlayer.seek(Duration.zero);
        await playerModel.mediaPlaybackHandler?.seek(Duration.zero);

      } else if (index + 1 < trackProv.audioPlayerTrackList.length) {

        const platform = MethodChannel('device_lock_status');
        bool isLockScreen = await platform.invokeMethod('isDeviceLocked');

        if (isLockScreen) {
          playerModel.carouselSliderController.jumpToPage(index + 1);
        } else {
          await playerModel.carouselSliderController.animateToPage(index + 1, duration: Duration(milliseconds: 500));
        }

      } else {
        if (playerModel.audioPlayerPlayOption == 1) {
          playerModel.currentPage = 0;
          playerModel.carouselSliderController.jumpToPage(0);
        } else {
          playerModel.isPlaying = false;
          stopTimer();
          await playerModel.audioPlayer.pause();
        }
        await playerModel.audioPlayer.seek(Duration.zero);
        await playerModel.mediaPlaybackHandler?.seek(Duration.zero);
      }
    }
  }

  void setTimer(TrackProv trackProv) async {

    if (playerModel.positionSubscription == null) {

      int prevPosition = 0;

      playerModel.positionSubscription?.cancel();
      playerModel.positionSubscription = playerModel.audioPlayer.positionStream.listen((position) async {

        if (prevPosition != position.inSeconds) {
          audioPlayerPositionUpdate();
          if (playerModel.totalDuration.inSeconds != 0) {
            if (prevPosition + 1 == playerModel.totalDuration.inSeconds) {
              prevPosition = 0;
              await playerModel.audioPlayer.pause();
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
    playerModel.positionSubscription?.cancel();
    playerModel.positionSubscription = null;
  }

  Future<void> handleAudioReset() async {
    audioPlayerClear();
    await playerModel.audioPlayer.pause();
    notify();
  }

  void pausePlay() {
    playerModel.isPlaying = false;
    stopTimer();
    playerModel.audioPlayer.pause();
    notify();
  }

  void resumePlay(TrackProv trackProv) {
    print('resumePlay()실행');
    playerModel.isPlaying = true;
    setTimer(trackProv);
    playerModel.audioPlayer.play();
    notify();
  }

  Future<void> togglePlayPause(bool isPlaying, TrackProv trackProv) async {
    if (isPlaying) {
      await playerModel.mediaPlaybackHandler?.pause();
    } else {
      await playerModel.mediaPlaybackHandler?.play();
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

    await playerModel.audioPlayer.seek(Duration(seconds: value.toInt()));

    if (isPlayBackUpdate) {
      await playerModel.mediaPlaybackHandler?.seek(Duration(seconds: value.toInt()));
    }
  }

  void setFullScreen() {
    playerModel.height = 100.h;
    playerModel.fullScreen = true;
    notify();
  }
}