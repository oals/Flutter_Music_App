import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    super.key,
    required this.title,
    required this.callBack,
  });

  final String title;
  final Function callBack;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{
        widget.callBack()
      },
      child: Container(
        width: 100.w,
        padding: EdgeInsets.only(left: 5,top: 15,bottom: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.5, // 선의 두께
              color: Colors.grey, // 선의 색상
            ),
          ),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
