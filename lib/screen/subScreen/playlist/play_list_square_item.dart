import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';


class PlayListSquareItem extends StatefulWidget {
  const PlayListSquareItem({
    super.key,
    
    required this.playList,
  });

  
  final List<PlayListModel> playList;

  @override
  State<PlayListSquareItem> createState() => _PlayListSquareItemState();
}

class _PlayListSquareItemState extends State<PlayListSquareItem> {
  @override
  Widget build(BuildContext context) {



    return Container(
      padding: EdgeInsets.only(left: 5,right: 5),
      child: Wrap(
        spacing: 20.0, // 아이템 간의 가로 간격
        runSpacing: 20.0, // 줄 간격
        alignment: WrapAlignment.spaceBetween,
        children: widget.playList.map((item) {

          return Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey,width: 2),
              borderRadius: BorderRadius.circular(10)
            ),
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/playList/${item.playListId}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/images/testImage4.png',
                          width: 40.w,
                          height: 20.h,
                          fit: BoxFit.fill,
                        ),
                      ),


                      Container(
                        width: 40.w,
                        height: 20.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9), // 하단은 어두운 색
                                Colors.transparent, // 상단은 투명
                              ],
                              stops: [0, 1.0],
                            ),
                          ),
                        ),

                      Positioned(
                          top : 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child:  ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              'assets/images/testImage4.png',
                              width: 20.w,
                              height: 10.h,
                            ),
                          ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Container(
                    width: 160,
                    child: Row(
                      children: [
                        Text(
                          item.playListNm!,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (item.isPlayListPrivacy == true)...[
                          SizedBox(width: 4,),
                          Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 13,
                          ),
                        ],
                      ],
                    ),
                  ),


                  Text(
                    item.memberNickName ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
