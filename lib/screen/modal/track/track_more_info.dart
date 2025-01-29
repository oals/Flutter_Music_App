import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';

class TrackMoreInfoScreen extends StatefulWidget {
  const TrackMoreInfoScreen({
    super.key,
    required this.track,
    required this.fnBottomModal,
  });

  final Track track;
  final Function fnBottomModal;

  @override
  State<TrackMoreInfoScreen> createState() => _TrackMoreInfoScreenState();
}

class _TrackMoreInfoScreenState extends State<TrackMoreInfoScreen> {

  bool isImageLoad = false;

  @override
  Widget build(BuildContext context) {

    PlayListProv playListProv = Provider.of<PlayListProv>(context);
    TrackProv trackProv = Provider.of<TrackProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);

    return Container(
      width: 100.w,
      height: 75.h,
      decoration: BoxDecoration(
       color: Colors.black
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, //0xff8515e7
              borderRadius: BorderRadius.circular(30),
            ),
            width: 50,
            height: 8,
          ),
          SizedBox(height: 25,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 3),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), // 원하는 둥글기 조정
                    child: CachedNetworkImage(
                      imageUrl: imageProv.imageLoader(widget.track.trackImagePath),  // 이미지 URL
                      placeholder: (context, url) {

                        return CircularProgressIndicator();  // 로딩 중에 표시할 위젯
                      },
                      errorWidget: (context, url, error) {
                        print('이미지 로딩 실패: $error');
                        return Icon(Icons.error);  // 로딩 실패 시 표시할 위젯
                      },
                      fadeInDuration: Duration(milliseconds: 500),  // 이미지가 로드될 때 페이드 인 효과
                      fadeOutDuration: Duration(milliseconds: 500),  // 이미지가 사라질 때 페이드 아웃 효과
                      width: 33.w,  // 이미지의 가로 크기
                      height: 16.h,  // 이미지의 세로 크기
                      fit: BoxFit.cover,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
                      imageBuilder: (context, imageProvider) {

                        return Image(
                            image: imageProvider,

                        );  // 이미지가 로드되면 표시
                      },
                    ),


                  ),
                ),
              ),
              SizedBox(width: 15,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 13,),
                  Text(
                    widget.track.trackNm!,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(widget.track.memberNickName ?? "",style: TextStyle(color: Colors.grey),),
                  SizedBox(height: 3,),
                  Text(
                    Helpers.getCategory(widget.track.trackCategoryId!),
                    style: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(height: 3,),
                  Row(
                    children: [
                      SvgPicture.asset(
                        width: 13,
                        height: 13,
                        'assets/images/play.svg',
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(widget.track.trackPlayCnt.toString(),style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Row(
                    children: [
                      SvgPicture.asset(
                        width: 13,
                        height: 13,
                        widget.track.trackLikeStatus! ? 'assets/images/heart_red.svg' : 'assets/images/heart.svg',
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(widget.track.trackLikeCnt.toString(),style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Text(widget.track.trackTime.toString(),style: TextStyle(color: Colors.white),),
                  SizedBox(height: 3,),


                ],
              ),


            ],
          ),

          SizedBox(height: 16),
          Container(
            width: 90.w,
            height: 0.6,
            color: Colors.grey,
          ),
          SizedBox(height: 7),
          GestureDetector(
            onTap: () async {
              print('플리에 추가 버튼 클릭');
              int? playListId = await widget.fnBottomModal(context,0, trackId : widget.track.trackId);

              print("음원 선택 아이디 : ${widget.track.trackId}");
              print('플리 선택 아이디 : ${playListId}');

              if(playListId != null) {
                playListProv.setPlayListTrack(playListId, widget.track.trackId!);
              }



            },
            child: Container(
              width: 94.w,
              padding: EdgeInsets.all(10),
              child: Text(
                "플레이리스트에 추가",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),


          GestureDetector(
            onTap: () async {
              print('좋아요 클릭');
              print(widget.track.trackId);
              await trackProv.setTrackLike(widget.track.trackId);
              Navigator.pop(context);
            },
            child: Container(
              width: 94.w,
              padding: EdgeInsets.all(10),
              child: Text(
                widget.track.trackLikeStatus! ? "관심 트랙에서 삭제" :"관심 트랙에 추가",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
