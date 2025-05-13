import 'dart:async'; // Timer 관련 라이브러리 추가
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/player/player.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/modal/audio_player_item.dart';
import 'package:skrrskrr/utils/helpers.dart';


class HLSStreamPage extends StatefulWidget {
  const HLSStreamPage({
    super.key,
  });

  @override
  _HLSStreamPageState createState() => _HLSStreamPageState();
}

class _HLSStreamPageState extends State<HLSStreamPage> {

  late TrackProv trackProv;
  late PlayerProv playerProv;
  late Future<bool> _getAudioPlayerTrackListFuture;
  bool isInit = false;
  bool isTrackLoad = false;

  @override
  void initState() {
    super.initState();
    print('HLSStreamPage');
    playerProv = Provider.of<PlayerProv>(context, listen: false);
    _getAudioPlayerTrackListFuture = Provider.of<TrackProv>(context, listen: false).getAudioPlayerTrackList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trackProv = Provider.of<TrackProv>(context);

    return Scaffold(
        body: FutureBuilder<bool>(
            future: _getAudioPlayerTrackListFuture, // 비동기 메소드 호출
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center();
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              } else {

                if (!isInit) {
                  int index = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId.toString() == trackProv.lastTrackId);
                  if (index != -1) {
                    playerProv.currentPage = index;
                    trackProv.audioPlayerTrackList[index].isPlaying = true;

                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      await playerProv.initAudio(trackProv, index);
                      await playerProv.playTrackAtIndex(index);
                      trackProv.notify();
                    });
                  }
                  isInit = true;
                }

                return trackProv.audioPlayerTrackList.isNotEmpty
                    ? CarouselSlider(
                  key: ValueKey(playerProv.currentPage),
                  controller: playerProv.carouselSliderController,
                  options: CarouselOptions(
                    initialPage : playerProv.currentPage,
                    height: 100.h,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    enlargeCenterPage: false,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!isTrackLoad) {
                          playerProv.handleAudioReset();
                          Future.delayed(Duration(milliseconds: 500), () async {
                            if ((index - playerProv.currentPage).abs() <= 1) {
                              isTrackLoad = true;
                              await playerProv.audioTrackMoveSetting(trackProv, index);
                              isTrackLoad = false;
                              playerProv.togglePlayPause(!playerProv.playerModel.isPlaying,trackProv);
                            }
                          });
                        }
                      });
                    },
                  ),
                  items: trackProv.audioPlayerTrackList.map((trackItem) {
                    return Builder(
                      builder: (BuildContext context) {
                        return AudioPlayerItem(audioPlayerTrackItem : trackItem);
                      },
                    );
                  }).toList(),
                ) : AudioPlayerItem(audioPlayerTrackItem : Track());

              }
          },
        ),
    );
  }
}



