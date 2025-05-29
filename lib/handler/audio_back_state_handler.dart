import 'package:audio_service/audio_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';

class AudioBackStateHandler extends BaseAudioHandler {
  final PlayerProv playerProv;
  final TrackProv trackProv;
  bool isPlaying = false;
  static AudioBackStateHandler? instance;

  factory AudioBackStateHandler(playerProv, trackProv, trackItem) {
    instance ??= AudioBackStateHandler.internal(playerProv, trackProv, trackItem);
    return instance!;
  }

  AudioBackStateHandler.internal(this.playerProv, this.trackProv, Track track) {
    mediaItemUpdate(track);
  }

  Future<void> deleteMediaItem() async {
    await pause();

    mediaItem.value = null;
    isPlaying = false;

    playbackState.add(
      PlaybackState(
        controls: [],
        androidCompactActionIndices: [],
        processingState: AudioProcessingState.idle,
        playing: false,
        systemActions: const {},
        updatePosition: Duration.zero,
        updateTime: DateTime.now(),
      ),
    );

    playerProv.playerModel.currentPosition = Duration.zero;
    playerProv.playerModel.totalDuration = Duration.zero;
    playerProv.notify();

    await AudioService.stop();

  }

  Future<void> mediaItemUpdate(Track track) async {

    List<String> timeParts = track.trackTime!.split(":");
    Duration? totalDuration = null;

    if (timeParts.length == 2) {
      int minutes = int.parse(timeParts[0]);
      int seconds = int.parse(timeParts[1]);

      totalDuration = Duration(minutes: minutes, seconds: seconds);
    } else {
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      int seconds = int.parse(timeParts[2]);

      totalDuration = Duration(hours: hours ,minutes: minutes, seconds: seconds);
    }

    this.mediaItem.value = MediaItem(
      id: track.trackId.toString(),
      title: "🎶 ${track.trackNm}",
      artist: "🎤 ${track.memberNickName}",
      artUri: Uri.parse(
          dotenv.get('API_URL') + '/viewer/imageLoader?trackImagePath=' +
              Uri.encodeComponent(track.trackImagePath ?? "")
      ),
      duration: totalDuration,
    );
  }

  @override
  Future<void> seek(Duration position) async {

    playbackState.add(
        playbackState.value.copyWith(
            updatePosition: position,
            playing : !isPlaying,
            processingState: AudioProcessingState.buffering

        )
    );

    await playerProv.onSliderChangeEnd(position.inSeconds.toDouble(), false);
    playerProv.playerModel.currentPosition = position;
    playerProv.playerModel.totalDuration = (this.mediaItem.value?.duration)!;

    playbackState.add(
        playbackState.value.copyWith(
            playing : isPlaying,
            processingState: AudioProcessingState.ready
        )
    );

    playerProv.notify();
  }

  void playbackStateUpdate() {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          isPlaying ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: [0, 1, 2],
        processingState: AudioProcessingState.ready,
        playing: isPlaying,
        systemActions: {MediaAction.seek},
        updatePosition: playerProv.playerModel.currentPosition,
        updateTime: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> play() async {
    isPlaying = true;
    playerProv.resumePlay(trackProv);
    playbackStateUpdate();
  }

  @override
  Future<void> pause() async {
    isPlaying = false;
    playerProv.pausePlay();
    playbackStateUpdate();
  }

  @override
  Future<void> skipToNext() async {
    if (playerProv.playerModel.currentPage + 1 < trackProv.audioPlayerTrackList.length) {
      playerProv.playerModel.carouselSliderController.jumpToPage(playerProv.playerModel.currentPage + 1);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (playerProv.playerModel.currentPage - 1 >= 0) {
      playerProv.playerModel.carouselSliderController.jumpToPage(playerProv.playerModel.currentPage - 1);
    }
  }

}
