import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';

class AudioPlayerTrackListModal extends StatefulWidget {
  const AudioPlayerTrackListModal({super.key});

  @override
  State<AudioPlayerTrackListModal> createState() =>
      _AudioPlayerTrackListModalState();
}

class _AudioPlayerTrackListModalState extends State<AudioPlayerTrackListModal> {
  late TrackProv trackProv;
  late PlayerProv playerProv;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    print('AudioPlayerTrackList InitState');
    setCurrentPlaying();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void setCurrentPlaying(){
    WidgetsBinding.instance.addPostFrameCallback((_) {

      int playingTrackIndex = trackProv.audioPlayerTrackList.indexWhere((trackItem) => trackItem.isPlaying == true);

      if (playingTrackIndex != -1 && scrollController.hasClients) {
        // 해당 인덱스 위치로 스크롤
        scrollController.animateTo(
          (playingTrackIndex - 2) * 10.h,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    trackProv = Provider.of<TrackProv>(context);
    playerProv = Provider.of<PlayerProv>(context);

    return Container(
      width: 100.w,
      height: 95.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Text(
                  'next up',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    for (int i = 0; i < trackProv.audioPlayerTrackList.length; i++) ...[
                      if (i == 0 && !trackProv.audioPlayerTrackList[i].isPlaying)
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 13),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Text(
                              'History',
                              key: ValueKey('History'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      if (trackProv.audioPlayerTrackList[i].isPlaying)
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 13),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Text(
                              'Currently playing',
                              key: ValueKey('CurrentlyPlaying'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      if (i != 0)
                        if (trackProv.audioPlayerTrackList[i - 1].isPlaying)
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, bottom: 13),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Text(
                                'Playing next',
                                key: ValueKey('PlayingNext_$i'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      AnimatedSize(
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                        child: Dismissible(
                          key: Key(trackProv.audioPlayerTrackList[i].trackId.toString()),
                          direction: trackProv.audioPlayerTrackList[i].isPlaying ? DismissDirection.none : DismissDirection.endToStart,
                          dismissThresholds: {
                            DismissDirection.endToStart: 0.6,
                          },
                          onDismissed: (direction) {
                            trackProv.audioPlayerTrackList.removeAt(i);
                            playerProv.removeTrack(i);
                            playerProv.currentPage = trackProv.audioPlayerTrackList.indexWhere((item) => item.trackId.toString() == trackProv.lastTrackId);
                            trackProv.audioPlayerTrackList = List.from(trackProv.audioPlayerTrackList);
                            setCurrentPlaying();

                            trackProv.notify();
                            playerProv.notify();
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: TrackListItem(
                            trackItem: trackProv.audioPlayerTrackList[i],
                            appScreenName: "AudioPlayerTrackListModal",
                            isAudioPlayer: true,
                            initAudioPlayerTrackListCallBack: () {},
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}