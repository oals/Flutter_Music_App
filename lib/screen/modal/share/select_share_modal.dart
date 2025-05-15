import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class SelectShareModal extends StatelessWidget {
  const SelectShareModal({
    super.key,
    required this.callBack,
  });

  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
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
                    onTap: (){
                      callBack("KakaoTalk");
                    },
                    child: ClipOval(
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        color: Colors.white10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            width: 12.w,
                            height: 6.h,
                            'assets/images/kakao_talk.svg',
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text("KakaoTalk",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      callBack("Twitter");
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
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),


              IconButton(
                icon: Icon(Icons.account_circle, color: Colors.white,size: 12.w,),
                onPressed: () {

                },
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
                      callBack("More");
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
