
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';

class AudioPlayerTrackListModal extends StatefulWidget {
  const AudioPlayerTrackListModal({
    super.key,
    required this.callBack,
  });

  final Function callBack;

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
        scrollController.animateTo(
          (playingTrackIndex - 2) * 10.h,
          duration: Duration(milliseconds: 600),
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
      height: 93.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8,right: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 32.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap:(){
                              widget.callBack();
                            },
                            child: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                  ),
                  Container(
                    width: 32.w,
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
                  Container(
                    width: 32.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        GestureDetector(
                          onTap: () {
                              if (playerProv.playerModel.audioPlayerPlayOption == 2) {
                                playerProv.playerModel.audioPlayerPlayOption = 0;
                              } else {
                                playerProv.playerModel.audioPlayerPlayOption++;
                              }
                              setState(() {});
                            },
                          child: Row(
                            children: [
                              if (playerProv.playerModel.audioPlayerPlayOption == 0)
                                Icon(Icons.repeat_rounded,color: Colors.grey, size: 26,),
                              if (playerProv.playerModel.audioPlayerPlayOption == 1)
                                Icon(Icons.repeat_rounded,color: Colors.white,size: 26),
                              if (playerProv.playerModel.audioPlayerPlayOption == 2)
                                Icon(Icons.repeat_one_rounded,color: Colors.white,size: 26),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          onDismissed: (direction) async {

                            if (trackProv.audioPlayerTrackList.length > 1) {

                              await trackProv.audioPlayerTrackList.removeAt(i);
                              await playerProv.removeTrack(i);

                              playerProv.currentPage = trackProv.audioPlayerTrackList.indexWhere(
                                      (item) => item.trackId.toString() == trackProv.lastTrackId);

                              trackProv.audioPlayerTrackList = List.from(trackProv.audioPlayerTrackList);

                              List<int> trackIdList = trackProv.audioPlayerTrackList.map((item) => int.parse(item.trackId.toString())).toList();
                              trackProv.setAudioPlayerTrackIdList(trackIdList);

                              playerProv.notify();
                            }
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          child: TrackListItem(
                            trackItem: trackProv.audioPlayerTrackList[i],
                            trackItemIdx : i,
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