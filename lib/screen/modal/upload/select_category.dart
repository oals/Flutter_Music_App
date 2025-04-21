import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({
    super.key,
    required this.callBack,
    required this.categoryId,
  });

  final Function callBack;
  final int? categoryId;

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
  late int? selectedCategorId;

  @override
  void initState() {
    super.initState();
    selectedCategorId = widget.categoryId;
  }


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
              child: Text(
                '카테고리',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100.w,
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(height: 20),

            Wrap(
              spacing: 10.0, // 위젯 사이의 가로 간격
              runSpacing: 20.0, // 줄 사이의 세로 간격
              children: [
                for (int i = 0; i < categoryList.length; i++)
                  GestureDetector(
                    onTap: () {
                      selectedCategorId = i;
                      setState(() {});
                    },
                    child: Container(
                      width: 30.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: selectedCategorId == i
                                ? Colors.white
                                : Colors.grey.withOpacity(0.7)
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          categoryList[i],
                          style: TextStyle(
                            color: selectedCategorId == i
                                ? Colors.white
                                : Colors.grey.withOpacity(0.7),
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            GestureDetector(
              onTap: (){
                widget.callBack(selectedCategorId);
              },
              child: Text('완료',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}