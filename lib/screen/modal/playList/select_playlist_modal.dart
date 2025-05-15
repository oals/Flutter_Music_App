import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';

class SelectPlaylistModal extends StatefulWidget {
  const SelectPlaylistModal({
    super.key,
    required this.trackId,
    required this.callBack,
  });

  final int trackId;
  final Function callBack;

  @override
  State<SelectPlaylistModal> createState() => _SelectPlaylistModalState();
}

class _SelectPlaylistModalState extends State<SelectPlaylistModal> {
  late PlayListProv playListProv;
  late Future<bool> _getPlayListInitFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPlayListInitFuture = Provider.of<PlayListProv>(context,listen: false).getPlayList(widget.trackId,0,false);
  }

  @override
  Widget build(BuildContext context) {

    playListProv = Provider.of<PlayListProv>(context);

    return Container(
      width: 100.w,
      height: 90.h,
      padding: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      child: FutureBuilder<bool>(
        future: _getPlayListInitFuture, // 데이터를 가져오는 함수
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중
            return Center(child: CustomProgressIndicatorItem());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('플레이리스트가 없습니다.'));
          }

          List<PlayListInfoModel> PlayLists = playListProv.playlists.playList;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'Add to playlist',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Wrap(
                        spacing: 7, // 가로 간격
                        runSpacing: 1, // 세로 간격
                        children: PlayLists.map((playlistItem) {
                          return GestureDetector(
                            onTap: () {
                              if (playlistItem.isInPlayList == true) {

                                Fluttertoast.showToast(
                                  msg: "이미 재생목록에 추가되어 있습니다.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black54,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );

                              } else {
                                widget.callBack(playlistItem.playListId);
                              }

                            },
                            child: SizedBox(
                              width: 45.w,
                              height: 25.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey, width: 1.5),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15.0),
                                          child: CustomCachedNetworkImage(
                                            imagePath: playlistItem.playListImagePath,
                                            imageWidth: 45.w,
                                            imageHeight: 20.h,
                                            isBoxFit: true,
                                          ),
                                        ),
                                      ),
                                      if (playlistItem.isInPlayList == true)...[
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 45.w,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.8),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10.h,
                                          left: 13.w,
                                          child: Text(
                                            'Already added',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ),
                                      ],

                                      Positioned(
                                        top: 10,
                                        right: 5,
                                        child: playlistItem.isPlayListPrivacy == true
                                            ? Icon(
                                          Icons.lock_sharp,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                            : SizedBox(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(width: 2.5.w),
                                      Expanded(
                                        child: Text(
                                          playlistItem.playListNm ?? "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                
                
                
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
