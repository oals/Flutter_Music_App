import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';

class AudioPlayerTrackListModal extends StatefulWidget {
  const AudioPlayerTrackListModal({super.key,});


  @override
  State<AudioPlayerTrackListModal> createState() => _AudioPlayerTrackListModalState();
}

class _AudioPlayerTrackListModalState extends State<AudioPlayerTrackListModal> {

  late TrackProv trackProv;

  @override
  Widget build(BuildContext context) {

    trackProv = Provider.of<TrackProv>(context);

    int playingTrackIndex = trackProv.audioPlayerTrackList.indexWhere((trackItem) => trackItem.isPlaying == true);


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
                // 재생목록 텍스트는 고정
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'next up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    Icon(
                      Icons.repeat_one,
                      color: Colors.white,
                    )

                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
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
                              key: ValueKey('History'), // 상태 변화 감지 키 설정
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

                      if (i + 4 > playingTrackIndex) ...[
                        AnimatedSize(
                          duration: Duration(seconds: 1),
                          curve: Curves.linear,
                          child: Dismissible(
                            key: Key(trackProv.audioPlayerTrackList[i].trackId.toString()),
                            direction: DismissDirection.endToStart,
                            dismissThresholds: {
                              DismissDirection.endToStart: 0.6, // 60% 이상 스와이프 시 삭제
                            },
                            onDismissed: (direction) {
                              trackProv.audioPlayerTrackList.removeAt(i);
                              trackProv.notify();
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                            child: TrackListItem(
                              trackItem: trackProv.audioPlayerTrackList[i],
                              isAudioPlayer: true,
                              callBack: () {},
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
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
