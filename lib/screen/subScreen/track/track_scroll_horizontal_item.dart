
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/image_prov.dart';


class TrackScrollHorizontalItem extends StatefulWidget {
  const TrackScrollHorizontalItem({
    super.key,
    required this.trackList,
    
  });

  final dynamic trackList;


  @override
  State<TrackScrollHorizontalItem> createState() => _TrackScrollHorizontalItemState();
}

class _TrackScrollHorizontalItemState extends State<TrackScrollHorizontalItem> {

  bool isImageLoad = false;

  @override
  Widget build(BuildContext context) {

    ImageProv imageProv = Provider.of<ImageProv>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < widget.trackList.length; i++) ...[
            GestureDetector(
              onTap: (){
                GoRouter.of(context).push('/musicInfo/${widget.trackList[i].trackId}');
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey,width: 2),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageProv.imageLoader(widget.trackList![i].trackImagePath),  // 이미지 URL
                          placeholder: (context, url) {

                            return CircularProgressIndicator();  // 로딩 중에 표시할 위젯
                          },
                          errorWidget: (context, url, error) {
                            print('이미지 로딩 실패: $error');
                            return Icon(Icons.error);  // 로딩 실패 시 표시할 위젯
                          },
                          fadeInDuration: Duration(milliseconds: 500),  // 이미지가 로드될 때 페이드 인 효과
                          fadeOutDuration: Duration(milliseconds: 500),  // 이미지가 사라질 때 페이드 아웃 효과
                          width: 28.w,
                          height: 15.h,  // 이미지의 세로 크기
                          fit: BoxFit.fill,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
                          imageBuilder: (context, imageProvider) {
                            return Image(image: imageProvider,fit: BoxFit.fill,);  // 이미지가 로드되면 표시
                          },
                        ),

                        Container(
                          width: 28.w,
                          height: 15.h,  // 이미지의 세로 크기
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.lightBlueAccent.withOpacity(0.9), // 하단은 어두운 색
                                Colors.transparent, // 상단은 투명
                              ],
                              stops: [0, 1.0],
                            ),
                          ),
                        ),

                      ],
                    ),


                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 120,
                      child: Text(
                        widget.trackList[i].trackNm,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      width: 120,
                      child: Text(
                        widget.trackList[i].memberNickName ?? "null",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20), // 간격 추가
          ],
        ],
      ),
    );
  }
}
