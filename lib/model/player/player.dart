import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class PlayerModel with ChangeNotifier{
  bool fullScreen = false;
  bool isPlaying = false;
  bool isBuffering = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  Timer? timer; // Timer 변수 추가
  double? height;
  // bool mounted = false;
  Offset dragOffset = Offset.zero;
  // ValueNotifier<Duration> positionNotifier = ValueNotifier<Duration>(Duration.zero);



}