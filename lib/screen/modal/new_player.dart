import 'dart:async'; // Timer 관련 라이브러리 추가
import 'package:card_swiper/card_swiper.dart';
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
    playerProv.swiperController = SwiperController();
  }

  @override
  void dispose() {
    playerProv.swiperController.dispose();
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
                      await playerProv.initAudio(trackProv);
                      await playerProv.playTrackAtIndex(index);
                      trackProv.notify();
                    });

                  }
                  isInit = true;
                }

                return trackProv.audioPlayerTrackList.isNotEmpty
                    ? Swiper(
                  key: ValueKey(playerProv.currentPage),
                  index: playerProv.currentPage,
                  itemCount: trackProv.audioPlayerTrackList.length,
                  controller: playerProv.swiperController,
                  scrollDirection: Axis.horizontal,
                  axisDirection: AxisDirection.left,
                  fade: 1.0,
                  // loop: playerProv.playerModel.audioPlayerPlayOption == 1 ? true : false,
                  loop: false,
                  autoplay: false,
                  onIndexChanged: (index) async {
                    print('호출 테스트');
                    print(index);

                    if (!isTrackLoad){
                      isTrackLoad = true;
                      await playerProv.audioTrackMoveSetting(trackProv, index);
                      isTrackLoad = false;
                      print("실행 완료 → 현재 인덱스: $index");
                    }

                  },
                  itemBuilder: (BuildContext ctx, int index) {
                    return AudioPlayerItem(audioPlayerTrackItem : trackProv.audioPlayerTrackList[index]);
                  },
                ) : AudioPlayerItem(audioPlayerTrackItem : Track());

              }
          },
        ),
    );
  }
}



