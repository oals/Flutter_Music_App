import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategorySquareItem extends StatefulWidget {
  const CategorySquareItem({
    super.key,
    required this.imagePath,
    required this.imageText,
    required this.imageSubText,
    required this.imageWidth,
  });
  final String imagePath;
  final String imageText;
  final String imageSubText;
  final double? imageWidth;

  @override
  State<CategorySquareItem> createState() => _CategorySquareItemState();
}

class _CategorySquareItemState extends State<CategorySquareItem> {
  @override
  Widget build(BuildContext context) {


    return Stack(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.imagePath,
                width: widget.imageWidth!.w,
                height: 15.h,
                fit: BoxFit.cover, // 이미지가 영역을 꽉 채우도록 설정
              ),
            ),
            Positioned(
                top: 0,
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.imageText,style: TextStyle(fontSize: 23,fontWeight: FontWeight.w800 ,color: Colors.white38),),
                    Text(widget.imageSubText,style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800 ,color: Colors.white),)
                  ],
                )
            ),
          ],
        ),

        Positioned(
          top : 0,
          left: 0,
          child: Container(
            width: widget.imageWidth!.w,
            height: 15.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xff1c1c1c).withOpacity(0.1), // 하단은 어두운 색
                  Colors.transparent, // 상단은 투명
                ],
                stops: [1.0, 1.0],
              ),
            ),
          ),
        ),

      ],
    );
  }
}
