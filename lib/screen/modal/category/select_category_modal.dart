import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Category',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              width: 100.w,
              height: 1,
              color: Colors.grey,
            ),

            SizedBox(height: 25),

            Wrap(
              spacing: 10.0, // 위젯 사이의 가로 간격
              runSpacing: 20.0, // 줄 사이의 세로 간격
                alignment : WrapAlignment.center,
              children: categoryList.map((category) {
                // 텍스트 크기 측정
                TextPainter textPainter = TextPainter(
                  text: TextSpan(
                    text: category,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  maxLines: 1,
                  textDirection: TextDirection.ltr,
                );
                textPainter.layout();

                double textWidth = textPainter.width + 10.w;

                return GestureDetector(
                  onTap: () {
                    selectedCategoryId = categoryList.indexOf(category);
                    setState(() {});
                  },
                  child: Container(
                    width: textWidth,
                    height: 5.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.5,
                        color: selectedCategoryId == categoryList.indexOf(category)
                            ? Colors.white
                            : Colors.grey.withOpacity(0.7),
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategoryId == categoryList.indexOf(category)
                              ? Colors.white
                              : Colors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 15,),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xff1c1c1c)), // 버튼 배경을 투명으로 설정
                shadowColor: WidgetStateProperty.all(Color(0xff1c1c1c)), // 그림자 제거
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
                )),
              ),
              onPressed: () {
                widget.callBack(selectedCategoryId);
              },
              child: Text(
                'save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}