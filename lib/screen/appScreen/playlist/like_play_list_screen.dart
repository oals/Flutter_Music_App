import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_lists_list_item.dart';

class LikePlayListScreen extends StatefulWidget {
  const LikePlayListScreen({
    super.key,
  });

  @override
  State<LikePlayListScreen> createState() => _LikePlayListScreenState();
}


class _LikePlayListScreenState extends State<LikePlayListScreen> {
  late PlayListProv playListProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool> _getLikePlayListInitFuture;

  @override
  void initState() {
    // TODO: implement initState
    print("MyPlayListScreen initstate");
    super.initState();
    _getLikePlayListInitFuture = Provider.of<PlayListProv>(context, listen: false).getLikePlayList( 0, false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    comnLoadProv.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    comnLoadProv = Provider.of<ComnLoadProv>(context);
    playListProv = Provider.of<PlayListProv>(context);

    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        child: FutureBuilder<bool>(
          future: _getLikePlayListInitFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            }

            PlaylistList playListList = playListProv.playlists;
            List<PlayListInfoModel> playLists = playListList.playList;

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (playListList.myPlayListTotalCount! > playLists.length) {
                  if (comnLoadProv.shouldLoadMoreData(notification)) {
                    comnLoadProv.loadMoreData(playListProv, "LikePlayLists", playLists.length , isAlbum: false);
                  }
                } else {
                  if (comnLoadProv.isApiCall){
                    comnLoadProv.resetApiCallStatus();
                  }
                }
                return false;
              },

              child: Stack(
                children: [

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child:  CustomAppbar(
                      fnBackBtnCallBack: () => {GoRouter.of(context).pop()},
                      fnUpdateBtnCallBack:()=>{},
                      title: "Liked PlayLists",
                      isNotification : false,
                      isEditBtn: false,
                      isAddTrackBtn : false,
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                for(int i = 0; i < playLists.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15,bottom: 5),
                                    child: PlayListsListItem(playList: playLists[i],isAlbum: false,),
                                  )
                              ],
                            ),
                          ),

                          CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
