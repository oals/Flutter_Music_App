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
              } else if (!snapshot.hasData) {
                return Center(child: Text('데이터가 없습니다.'));
              } else {

                if(!isInit){
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

                print('오디오빌드');

                return trackProv.audioPlayerTrackList.isNotEmpty
                    ? Swiper(
                  index: playerProv.currentPage,
                  controller: playerProv.swiperController,
                  scrollDirection: Axis.horizontal, // 슬라이드 방향
                  axisDirection: AxisDirection.left, // 정렬
                  loop: false,// 반복
                  autoplay: false,// 자동 슬라이드
                  duration: 600,// 속도
                  itemCount: trackProv.audioPlayerTrackList.length,
                  onIndexChanged: (index) async {

                    print("오디오 이동");

                    if (playerProv.page == index){
                      playerProv.page = -1;
                    }

                    if (playerProv.page == -1 ){

                      playerProv.audioPlayerClear();
                      playerProv.togglePlayPause(!playerProv.playerModel.isPlaying,trackProv);

                      if (trackProv.audioPlayerTrackList.length > playerProv.currentPage) {
                        trackProv.audioPlayerTrackList[playerProv.currentPage].isPlaying = false;
                      }

                      trackProv.audioPlayerTrackList[index].isPlaying = true;

                      playerProv.currentPage = index;
                      await playerProv.playTrackAtIndex(playerProv.currentPage);

                      if (trackProv.lastListenTrackList[0].trackId != trackProv.audioPlayerTrackList[index].trackId!) {
                        trackProv.updateLastListenTrackList(trackProv.audioPlayerTrackList[index]);
                      }

                      await trackProv.setLastListenTrackId(trackProv.audioPlayerTrackList[index].trackId!);
                      trackProv.notify();
                    }
                  },
                  itemBuilder: (BuildContext ctx, int index) {
                    return AudioPlayerItem(audioPlayerTrackItem : trackProv.audioPlayerTrackList[index]);
                  },
                )
                    : AudioPlayerItem(audioPlayerTrackItem : Track());

              }
          },
        ),
    );
  }
}



