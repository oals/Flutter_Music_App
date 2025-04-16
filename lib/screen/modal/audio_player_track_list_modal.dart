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



    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                // 재생목록 텍스트는 고정
                child: Text(
                  '재생목록',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Expanded(
              // 하단 콘텐츠에 스크롤 적용
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    for (int i = 0; i < trackProv.audioPlayerTrackList.length; i++) ...[
                      TrackListItem(
                        trackItem: trackProv.audioPlayerTrackList[i],
                        callBack: () {},
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
