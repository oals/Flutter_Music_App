import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAudioPlayerBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomAudioPlayerBottomNavigation({required this.currentIndex, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // 네비게이션 바 높이
      decoration: BoxDecoration(
        color: Colors.black, // 배경색
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem('assets/images/heart.svg', '', 0,20.w),
          _buildNavItem('assets/images/comment.svg', '', 1,20.w),
          _buildNavItem('assets/images/dotPoints.svg', '', 2,20.w),
          _buildNavItem('assets/images/more.svg', '', 3,20.w),
        ],
      ),
    );
  }

  Widget _buildNavItem(String svgPath, String label, int index, double width) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: width,
        padding: EdgeInsets.only(left: 10,right: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SvgPicture.asset(
                  svgPath,
                width: 23,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: TextStyle(
                    color: isSelected == 0 ? Colors.grey : Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 17),
              ),
            ]),
      ),
    );
  }
}
