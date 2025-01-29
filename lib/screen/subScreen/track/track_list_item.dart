import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';

import 'package:skrrskrr/utils/helpers.dart';

class TrackListItem extends StatefulWidget {
  const TrackListItem({
    super.key,
    required this.trackItem,
    
    
  });

  final dynamic trackItem;
  


  @override
  State<TrackListItem> createState() => _TrackListItemState();
}

class _TrackListItemState extends State<TrackListItem> {

  bool isImageLoad = false;

  @override
  Widget build(BuildContext context) {

    ImageProv imageProv = Provider.of<ImageProv>(context);

    return GestureDetector(
      onTap: (){
        print('음원 실행');
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      print('음원상세페이지 이동');
                      GoRouter.of(context).push('/musicInfo/${widget.trackItem.trackId}');
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey,width: 2),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0), // 원하는 둥글기 조정
                        child: CachedNetworkImage(
                          imageUrl: imageProv.imageLoader(widget.trackItem.trackImagePath),  // 이미지 URL
                          placeholder: (context, url) {

                            return CircularProgressIndicator();  // 로딩 중에 표시할 위젯
                          },
                          errorWidget: (context, url, error) {
                            print('이미지 로딩 실패: $error');
                            return Icon(Icons.error);  // 로딩 실패 시 표시할 위젯
                          },
                          fadeInDuration: Duration(milliseconds: 500),  // 이미지가 로드될 때 페이드 인 효과
                          fadeOutDuration: Duration(milliseconds: 500),  // 이미지가 사라질 때 페이드 아웃 효과
                          width: 10.w,  // 이미지의 가로 크기
                          // height: maxHeight * 0.07,  // 이미지의 세로 크기
                          fit: BoxFit.cover,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
                          imageBuilder: (context, imageProvider) {

                            return Image(image: imageProvider,);  // 이미지가 로드되면 표시
                          },
                        ),

                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.trackItem.trackNm}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          if(widget.trackItem.trackLikeStatus!)...[
                            SizedBox(width: 3,),
                            SvgPicture.asset(
                              'assets/images/heart_red.svg',
                              color: Color(0xffff0000),
                              width: 15,
                              height: 15,
                            ),
                          ]
                        ],
                      ),
                      if(widget.trackItem.memberNickName != null)
                        Text(
                        '${widget.trackItem.memberNickName}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          if(widget.trackItem.trackTime != null)
                            Text(
                              '${widget.trackItem.trackTime}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          // SizedBox(width: 5,),
                          // Text(
                          //   Helpers.getCategory(widget.trackItem.trackCategoryId),
                          //   style: TextStyle(
                          //     color: Colors.grey,
                          //     fontSize: 12,
                          //   ),
                          // ),


                        ],
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  print('123123');
                  print(widget.trackItem.trackId);
                  AppBottomModalRouter.fnModalRouter(context,3,
                    track : widget.trackItem,
                  );
                },
                child: SvgPicture.asset(
                  'assets/images/ellipsis.svg',
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.09,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
