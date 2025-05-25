import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider_plus/carousel_controller.dart';

class PlayerModel with ChangeNotifier{
  bool fullScreen = false;
  bool isPlaying = false;
  bool isBuffering = false;
  int audioPlayerPlayOption = 0;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double? height;
  Offset dragOffset = Offset.zero;

  AudioHandler? mediaPlaybackHandler = null;
  CarouselSliderController carouselSliderController = CarouselSliderController();
  Completer<void>? currentRequest;
  StreamSubscription? positionSubscription = null;
  String? currentAppScreen = "";
  int currentPage = 0;
}