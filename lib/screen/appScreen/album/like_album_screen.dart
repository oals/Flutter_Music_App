import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_lists_list_item.dart';

class LikeAlbumScreen extends StatefulWidget {
  const LikeAlbumScreen({
    super.key,
    required this.adminId,
  });

  final int? adminId;

  @override
  State<LikeAlbumScreen> createState() => _LikeAlbumScreenState();
}

class _LikeAlbumScreenState extends State<LikeAlbumScreen> {
  late PlaylistList playListModel;
  late PlayListProv playListProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool> _getLikePlayListInitFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLikePlayListInitFuture = Provider.of<PlayListProv>(context, listen: false).getLikePlayList(0, true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    comnLoadProv.clear();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    playListProv = Provider.of<PlayListProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);

    return Scaffold(
      body: Container(
        height: 100.h,
        color: Colors.black,
        child: FutureBuilder<bool>(
          future: _getLikePlayListInitFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            }

            PlaylistList playListList = playListProv.playlists;
            List<PlayListInfoModel> AlbumList = playListProv.playlists.playList;

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (playListList.myPlayListTotalCount! > AlbumList.length) {
                  if (comnLoadProv.shouldLoadMoreData(notification)) {
                    comnLoadProv.loadMoreData(playListProv, "LikePlayLists", AlbumList.length , isAlbum: true);
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAppbar(
                            fnBackBtncallBack: () => {GoRouter.of(context).pop()},
                            fnUpdtBtncallBack:()=>{},
                            title: "Album",
                            isNotification : false,
                            isEditBtn: false,
                            isAddTrackBtn : false,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          for(int i = 0; i < AlbumList.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(left: 15,bottom: 5),
                              child: PlayListsListItem(playList: AlbumList[i],isAlbum: false),
                            )
                        ],
                      ),
                    ),

                    Center(
                        child: CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall),
                    ),
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
