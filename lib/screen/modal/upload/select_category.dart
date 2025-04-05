import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/screen/subScreen/upload/category_item.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({
    super.key,
    required this.callBack,
  });

  final Function callBack;

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {

  List<String> categoryList = [
    'K-Pop',
    'HipHop',
    'Beats',
    'Rock',
    'R&B',
    'Ballad',
    'Dj',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text('카테고리',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                fontSize: 17,
              ),),
            ),
            SizedBox(height: 10,),
            for(int i = 0; i< categoryList.length; i++)
              CategoryItem(title : categoryList[i],callBack: ()=>{
                  widget.callBack(categoryList[i],i),
                  // GoRouter.of(context).pop(),
                },
              ),
          ],
        ),
      ),
    );
  }
}
