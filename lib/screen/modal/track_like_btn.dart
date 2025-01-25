import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/track_prov.dart';

class TrackLikeBtn extends StatefulWidget {
  const TrackLikeBtn({
    super.key,
    required this.trackInfoModel,
  });

  final dynamic trackInfoModel;

  @override
  State<TrackLikeBtn> createState() => _TrackLikeBtnState();
}

class _TrackLikeBtnState extends State<TrackLikeBtn> {
  @override
  Widget build(BuildContext context) {
    TrackProv trackProv = Provider.of<TrackProv>(context);

    print('좋아요상태');
    print(widget.trackInfoModel.trackLikeStatus);

    return Row(
      children: [
        GestureDetector(
          onTap: (){
            print('좋아요 클릭');
            trackProv.setTrackLike(widget.trackInfoModel.trackId);
            setState(() {
              widget.trackInfoModel.trackLikeStatus = !widget.trackInfoModel.trackLikeStatus!;
              if(widget.trackInfoModel.trackLikeStatus!){
                widget.trackInfoModel.trackLikeCnt = widget.trackInfoModel.trackLikeCnt! + 1;
              }else {
                widget.trackInfoModel.trackLikeCnt = widget.trackInfoModel.trackLikeCnt! - 1;
              }
            });
          },
          child: SvgPicture.asset(
            widget.trackInfoModel.trackLikeStatus!
                ? 'assets/images/heart_red.svg'
                : 'assets/images/heart.svg' ,
            width: 27,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          widget.trackInfoModel.trackLikeCnt.toString(),
          style:
          TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }
}
