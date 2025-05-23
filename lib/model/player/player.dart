import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class PlayerModel with ChangeNotifier{
  bool fullScreen = false;
  bool isPlaying = false;
  bool isBuffering = false;
  int audioPlayerPlayOption = 0;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double? height;
  Offset dragOffset = Offset.zero;


}