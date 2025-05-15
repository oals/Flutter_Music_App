import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/screen/subScreen/comn/button/track_comment_btn_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/button/track_like_btn_item.dart';

class CustomAudioPlayerBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final dynamic trackInfoModel;
  final int? commentsCnt;

  CustomAudioPlayerBottomNavigation({required this.currentIndex, required this.onTap, this.commentsCnt, this.trackInfoModel,});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 5.h, // 네비게이션 바 높이
      decoration: BoxDecoration(
        color: Colors.transparent, // 배경색
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 40,right :40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TrackLikeBtnItem(track: trackInfoModel),
            _buildNavItem('assets/images/comment.svg', '', 1,20.w),
            _buildNavItem('assets/images/dotPoints.svg', '', 2,20.w),
            _buildNavItem('assets/images/more.svg', '', 3,20.w),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String svgPath, String label, int index, double width) {

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        child: SvgPicture.asset(
            svgPath,
          width: 23,
        ),
      ),
    );
  }
}
