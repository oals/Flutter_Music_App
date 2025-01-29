import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TrackInfoEdit extends StatefulWidget {
  const TrackInfoEdit({
    super.key,
    required this.trackInfo,
    required this.onSave, // 저장 시 부모 위젯에 변경된 값 전달
  });

  final String trackInfo;  // 초기 텍스트
  final Function(String) onSave;  // 수정된 텍스트를 부모 위젯으로 전달하는 콜백

  @override
  State<TrackInfoEdit> createState() => _TrackInfoEditState();
}

class _TrackInfoEditState extends State<TrackInfoEdit> {
  late TextEditingController _editConntroller;

  @override
  void initState() {
    super.initState();
    _editConntroller = TextEditingController(text: widget.trackInfo);
  }

  @override
  void dispose() {
    _editConntroller.dispose();  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 100.w,
        height: 40.h,
        color: Color(0xff200f2e),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                '편집',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Material(
              child: TextField(
                controller: _editConntroller,
                maxLines: 5,  // 여러 줄 텍스트 입력 가능
                decoration: InputDecoration(
                  fillColor: const Color(0xff8515e7),
                  hintText: '음원 소개를 입력하세요.',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave(_editConntroller.text); // 수정된 텍스트를 부모 위젯으로 전달
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: Text('저장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
