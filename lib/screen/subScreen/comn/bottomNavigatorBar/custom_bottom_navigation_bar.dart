import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // 네비게이션 바 높이
      decoration: BoxDecoration(
        color: Colors.black, // 배경색
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'LoFi', 0,33.w),
          // _buildNavItem(Icons.feed, '', 1,20.w),
          _buildNavItem(Icons.search, '', 2,33.w),
          _buildNavItem(Icons.settings, '', 3,33.w),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, double width) {
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
              Icon(
                icon,
                size: 30,
                color: isSelected ? Colors.white : Colors.grey,
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
