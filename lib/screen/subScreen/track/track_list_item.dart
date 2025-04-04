import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';

import 'package:skrrskrr/utils/helpers.dart';

import '../../../model/player/player.dart';

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

    TrackProv trackProv = Provider.of<TrackProv>(context);
    AppProv appProv = Provider.of<AppProv>(context,listen: false);
    PlayerProv playerProv = Provider.of<PlayerProv>(context,listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                await trackProv.setLastListenTrackId(widget.trackItem.trackId);

                await playerProv.audioPause();
                appProv.reload();

              },
              child: Row(
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
                        child: CustomCachedNetworkImage(
                            imagePath: widget.trackItem.trackImagePath,
                            imageWidth : 15.w,
                            imageHeight : null
                        ),

                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(
                          width: 57.w,
                          child: Text(
                            '${widget.trackItem.trackNm}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 2,),
                        Row(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/play.svg',
                                  width: 12,
                                  height: 12,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 1,),
                                Text(
                                  '${widget.trackItem.trackPlayCnt}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5,),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  widget.trackItem.trackLikeStatus ? 'assets/images/heart_red.svg' : 'assets/images/heart.svg',
                                  width: 15,
                                  height: 15,
                                ),
                                SizedBox(width: 1,),
                                Text(
                                  '${widget.trackItem.trackLikeCnt}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        SizedBox(height: 1,),
                        Row(
                          children: [
                            Text(
                              '${widget.trackItem.trackTime}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              Helpers.getCategory(widget.trackItem.trackCategoryId),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                          Row(
                            children: [
                              ClipOval(
                                child: CustomCachedNetworkImage(
                                  imagePath: widget.trackItem.memberImagePath,
                                  imageWidth: 4.5.w,
                                  imageHeight: null,
                                ),
                              ),
                              SizedBox(width: 5,),
                              Text(
                                '${widget.trackItem.memberNickName}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
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
    );
  }
}
