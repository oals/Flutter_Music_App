
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';


class TrackScrollHorizontalItem extends StatefulWidget {
  const TrackScrollHorizontalItem({
    super.key,
    required this.trackList,
  });
  final List<Track> trackList;



  @override
  State<TrackScrollHorizontalItem> createState() => _TrackScrollHorizontalItemState();
}

class _TrackScrollHorizontalItemState extends State<TrackScrollHorizontalItem> {

  bool isImageLoad = false;
  late TrackProv trackProv;

  @override
  Widget build(BuildContext context) {

    trackProv = Provider.of<TrackProv>(context,listen: false);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [

          Wrap(
            spacing: 5.0, // 아이템 간의 가로 간격
            runSpacing: 20.0, // 줄 간격
            alignment: WrapAlignment.spaceBetween,
            children: widget.trackList.map((item) {
              return Row(
                children: [
                  TrackSquareItem(
                    trackItem: item,
                    callBack: () async {

                      List<int> trackIdList = widget.trackList.map((item) => int.parse(item.trackId.toString())).toList();
                      trackProv.audioPlayerTrackList = widget.trackList;
                      await trackProv.setAudioPlayerTrackIdList(trackIdList);
                      trackProv.notify();

                    },
                  ),
                  SizedBox(width: 3,),
                ],
              );
            }).toList(),
          ),

        ],
      ),
    );
  }
}
