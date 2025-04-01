
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/track/track_square_item.dart';


class TrackScrollHorizontalItem extends StatefulWidget {
  const TrackScrollHorizontalItem({
    super.key,
    required this.trackList,
    required this.bgColor
    
  });

  final dynamic trackList;
  final Color bgColor;


  @override
  State<TrackScrollHorizontalItem> createState() => _TrackScrollHorizontalItemState();
}

class _TrackScrollHorizontalItemState extends State<TrackScrollHorizontalItem> {

  bool isImageLoad = false;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < widget.trackList.length; i++) ...[
            TrackSquareItem(
              track: widget.trackList[i],
              bgColor: widget.bgColor,
            ),
            SizedBox(width: 15,),
          ],
        ],
      ),
    );
  }
}
