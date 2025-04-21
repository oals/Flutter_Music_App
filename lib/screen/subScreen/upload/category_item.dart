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
        width: 40.w,
        height: 5.h,
        decoration: BoxDecoration(
          border: Border.all(width: 2,color: Colors.grey),
          borderRadius: BorderRadius.circular(100)
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
