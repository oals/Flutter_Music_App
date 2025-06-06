import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ComnEditModal extends StatefulWidget {
  const ComnEditModal({
    super.key,
    required this.infoText,
    required this.maxLines,
    required this.onSave,
  });

  final String infoText;
  final int? maxLines;
  final Function(String) onSave;

  @override
  State<ComnEditModal> createState() => _ComnEditModalState();
}

class _ComnEditModalState extends State<ComnEditModal> {
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.infoText);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              child: TextField(
                controller: _editController,
                maxLines: widget.maxLines,
                decoration: InputDecoration(
                  hintText: 'Type here.',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Color(0xff1c1c1c)), // 버튼 배경을 투명으로 설정
                  shadowColor: WidgetStateProperty.all(Color(0xff1c1c1c)), // 그림자 제거
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
                  )),
                ),
                onPressed: () {
                  widget.onSave(_editController.text);
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
        ],
      ),
    );
  }
}
