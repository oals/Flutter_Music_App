import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/comn/messages/empty_message_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/playlist_item.dart';

class SearchAlbumScreen extends StatefulWidget {
  const SearchAlbumScreen({
    super.key,
    required this.searchText,
  });

  final String searchText;

  @override
  State<SearchAlbumScreen> createState() => _SearchAlbumScreenState();
}

class _SearchAlbumScreenState extends State<SearchAlbumScreen> {
  late PlayListProv playListProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool>? _getSearchPlayListFuture;

  @override
  void initState() {
    super.initState();
    _getSearchPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getSearchPlayList(widget.searchText,0,20,true);
  }

  @override
  void dispose() {
    comnLoadProv.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    playListProv = Provider.of<PlayListProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);

    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black,
      child: FutureBuilder<bool>(
          future: _getSearchPlayListFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else {

              PlaylistList albumList = playListProv.albums;
              List<PlayListInfoModel> searchAlbums = albumList.playList;

              return NotificationListener <ScrollNotification>(
                onNotification: (notification) {
                  if (albumList.searchPlayListTotalCount! > searchAlbums.length) {
                    if (comnLoadProv.shouldLoadMoreData(notification)) {
                      comnLoadProv.loadMoreData(playListProv, "SearchAlbum", searchAlbums.length , searchText: widget.searchText);
                    }
                  } else {
                    if (comnLoadProv.isApiCall) {
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
                      child: CustomAppbar(
                        fnBackBtnCallBack: () => {GoRouter.of(context).pop()},
                        fnUpdateBtnCallBack:()=>{},
                        title: "Albums",
                        isNotification : false,
                        isEditBtn: false,
                        isAddTrackBtn : false,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (searchAlbums.length == 0)
                              EmptyMessageItem(paddingHeight: 30.h),

                            if (searchAlbums.length != 0) ...[
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0 ; i < searchAlbums.length; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15, bottom: 5.0),
                                        child: PlaylistItem(playList: searchAlbums[i],isAlbum: true),
                                      ),

                                  ],
                                ),
                              ),
                              CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall)


                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}
