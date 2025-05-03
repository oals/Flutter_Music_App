import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/track_prov.dart';


class TrackLikeBtn extends StatefulWidget {
  const TrackLikeBtn({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<TrackLikeBtn> createState() => _TrackLikeBtnState();
}

class _TrackLikeBtnState extends State<TrackLikeBtn> {
  late TrackProv trackProv;

  @override
  Widget build(BuildContext context) {
    trackProv = Provider.of<TrackProv>(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await trackProv.setTrackLike(widget.track.trackId);
            trackProv.fnUpdateTrackLikeStatus(widget.track);
            trackProv.notify();
          },
          child: SvgPicture.asset(
            widget.track.isTrackLikeStatus!
                ? 'assets/images/heart_red.svg'
                : 'assets/images/heart.svg' ,
            width: 27,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          widget.track.trackLikeCnt.toString(),
          style:
          TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}
