import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';

class NewPlayListScreen extends StatefulWidget {
  const NewPlayListScreen({super.key});

  @override
  State<NewPlayListScreen> createState() => _NewPlayListScreenState();
}

class _NewPlayListScreenState extends State<NewPlayListScreen> {
  final TextEditingController textController = TextEditingController();
  bool _isToggled = true;
  bool isAlbumPrivacy = true;

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    PlayListProv playListProv = Provider.of<PlayListProv>(context);

    return Container(
      width: 100.w,
      height: 75.h,
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [

          Text(
            "생성",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700
            ),
          ),
          SizedBox(height: 36),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: '플레이리스트명',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white), // 입력 텍스트 색상을 흰색으로 설정
          ),

          SizedBox(height: 26),
          Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: Color(0xff1c1c1c),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 5, color: Color(0xff1c1c1c)),
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isToggled = !_isToggled;
                    isAlbumPrivacy = _isToggled;
                  });
                },
                child: Center(
                    child: Text(
                  !_isToggled ? '공개' : '비공개',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),),
              ),),
          SizedBox(height: 16),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(0xff1c1c1c)), // 버튼 배경을 투명으로 설정
              shadowColor: WidgetStateProperty.all(Color(0xff1c1c1c)), // 그림자 제거
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
              )),
            ),
            onPressed: () {
              // 플레이리스트 생성 메서드 호출

              playListProv.setNewPlaylist(
                  textController.text, isAlbumPrivacy,false);

              GoRouter.of(context).pop(); // 바텀 시트 닫기
            },
            child: Text('생성',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
