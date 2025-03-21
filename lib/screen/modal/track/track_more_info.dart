import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
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
  bool isAuth = false;
  late String? loginMemberId;

  @override
  void initState() {
    super.initState();
    _loadMemberId();
  }

  void _loadMemberId() async {
    loginMemberId = await Helpers.getMemberId();
    isAuth = getIsAuth(widget.track.memberId);
    setState(() {});
  }

  bool getIsAuth(checkMemberId)  {
    return checkMemberId == loginMemberId;
  }


  @override
  Widget build(BuildContext context) {

    PlayListProv playListProv = Provider.of<PlayListProv>(context);
    TrackProv trackProv = Provider.of<TrackProv>(context);


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
                    child: CustomCachedNetworkImage(
                        imagePath:widget.track.trackImagePath,
                        imageWidth : 33.w,
                        imageHeight : 16.h
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
                        width: 16,
                        height: 16,
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
              GoRouter.of(context).pop();
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

        if(isAuth)
          GestureDetector(
            onTap: () async {
              print(widget.track.trackId);
              await trackProv.setLockTrack(widget.track.trackId,true);
              GoRouter.of(context).pop();
            },
            child: Container(
              width: 94.w,
              padding: EdgeInsets.all(10),
              child: Text(
                "트랙 비공개로 변경",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
