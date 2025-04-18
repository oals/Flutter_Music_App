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
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_lists_list_item.dart';

class MyPlayListScreen extends StatefulWidget {
  const MyPlayListScreen({
    super.key,
  });

  @override
  State<MyPlayListScreen> createState() => _MyPlayListScreenState();
}


class _MyPlayListScreenState extends State<MyPlayListScreen> {
  late PlayListProv playListProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool> _getPlayListInitFuture;

  @override
  void initState() {
    // TODO: implement initState
    print("MyPlayListScreen initstate");
    super.initState();
    _getPlayListInitFuture = Provider.of<PlayListProv>(context, listen: false).getPlayList(0, 0, false);
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
        height: 100.h,
        color: Colors.black,
        child: FutureBuilder<bool>(
          future: _getPlayListInitFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            }

            PlaylistList playListList = playListProv.playlists;
            List<PlayListInfoModel> playLists = playListList.playList;

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (playListList.myPlayListTotalCount! > playLists.length) {
                  if (comnLoadProv.shouldLoadMoreData(notification)) {
                    comnLoadProv.loadMoreData(playListProv, "PlayLists", playLists.length, trackId: 0 , isAlbum: false);
                  }
                } else {
                  if (comnLoadProv.isApiCall){
                    comnLoadProv.resetApiCallStatus();
                  }
                }
                return false;
              },

              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAppbar(
                            fnBackBtncallBack: () => {GoRouter.of(context).pop()},
                            fnUpdtBtncallBack:()=>{},
                            title: "PlayLists",
                            isNotification : false,
                            isEditBtn: false,
                            isAddPlayListBtn : true,
                            isAddTrackBtn : false,
                            isAddAlbumBtn : false,
                          ),
                          SizedBox(
                            height: 20,
                          ),

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
            );
          },
        ),
      ),
    );
  }
}
