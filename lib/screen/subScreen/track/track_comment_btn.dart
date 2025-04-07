import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';

class TrackCommentBtn extends StatefulWidget {
  const TrackCommentBtn({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<TrackCommentBtn> createState() => _TrackCommentBtnState();
}

class _TrackCommentBtnState extends State<TrackCommentBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            AppBottomModalRouter.fnModalRouter(context, 0, trackId: widget.track.trackId);
          },
          child: SvgPicture.asset(
            'assets/images/comment.svg',
            width: 27,
          ),
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          widget.track.commentsCnt.toString(),
          style:
          TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}
