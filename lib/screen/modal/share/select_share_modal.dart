import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/utils/share_utils.dart';

class SelectShareModal extends StatefulWidget {
  const SelectShareModal({
    super.key,
    required this.callBack,
  });

  final Function callBack;

  @override
  State<SelectShareModal> createState() => _SelectShareModalState();
}

class _SelectShareModalState extends State<SelectShareModal> {
  bool isTwitterInstalled = false;
  bool isKakaoTalkInstalled = false;
  bool isLineInstalled = false;

  @override
  void initState() {
    super.initState();
    checkInstalledApps();
  }

  Future<void> checkInstalledApps() async {
    isTwitterInstalled = await ShareUtils.isShareAppInstalled("com.twitter.android");
    isKakaoTalkInstalled = await ShareUtils.isShareAppInstalled("com.kakao.talk");
    isLineInstalled = await ShareUtils.isShareAppInstalled("jp.naver.line.android");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
        border: Border(
          top: BorderSide(width: 5, color: Colors.white10), // 윗부분만 적용
        ),
      ),
      width: 100.w,
      height: 18.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Share",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {

                      if (isKakaoTalkInstalled) {
                        widget.callBack("KakaoTalk");
                      } else {
                        ShareUtils.openPlayStore("com.kakao.talk");
                      }

                    },
                    child: ClipOval(
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                width: 12.w,
                                height: 6.h,
                                'assets/images/kakao_talk.svg',
                              ),

                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ClipOval(
                                  child: Container(
                                    width: 12.w,
                                    height: 6.h,
                                    color: Colors.white10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text( "KakaoTalk",
                    style: TextStyle(
                        color: isKakaoTalkInstalled ? Colors.white : Colors.white10,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async{
                      if (isTwitterInstalled) {
                        widget.callBack("X");
                      } else {
                        ShareUtils.openPlayStore("com.twitter.android");
                      }
                    },
                    child: ClipOval(
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            width: 7.w,
                            height: 3.5.h,
                            'assets/images/twitter.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text("X",
                    style: TextStyle(
                        color: isTwitterInstalled ? Colors.white : Colors.white10,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (isLineInstalled) {
                        widget.callBack("Line");
                      } else {
                        ShareUtils.openPlayStore("jp.naver.line.android");
                      }
                    },
                    child: ClipOval(
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            width: 7.w,
                            height: 3.5.h,
                            'assets/images/line.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text("Line",
                    style: TextStyle(
                        color: isLineInstalled ? Colors.white : Colors.white10,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),

              Column(
                children: [
                  IconButton(
                    icon: ClipOval(
                      child: Container(
                        width: 12.w,
                          height: 6.h,
                          color: Colors.white10,
                          child: Icon(Icons.more_horiz, color: Colors.white,size: 5.w,)),
                    ),
                    onPressed: () {
                      widget.callBack("More");
                    },
                  ),
                  Text("More",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
