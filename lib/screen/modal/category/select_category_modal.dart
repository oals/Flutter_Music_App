import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class SelectCategoryModal extends StatefulWidget {
  const SelectCategoryModal({
    super.key,
    required this.callBack,
    required this.categoryId,
  });

  final Function callBack;
  final int? categoryId;

  @override
  State<SelectCategoryModal> createState() => _SelectCategoryModalState();
}

class _SelectCategoryModalState extends State<SelectCategoryModal> {

  late int? selectedCategoryId;
  late List<String> categoryList;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categoryId;
    categoryList = ComnUtils.categoryList!;
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
                for (int i = 0; i < categoryList!.length; i++)
                  GestureDetector(
                    onTap: () {
                      selectedCategoryId = i;
                      setState(() {});
                    },
                    child: Container(
                      width: 30.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: selectedCategoryId == i
                                ? Colors.white
                                : Colors.grey.withOpacity(0.7)
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          categoryList![i],
                          style: TextStyle(
                            color: selectedCategoryId == i
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
                widget.callBack(selectedCategoryId);
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