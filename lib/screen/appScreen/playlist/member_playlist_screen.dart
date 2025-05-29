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
import 'package:skrrskrr/screen/subScreen/playlist/playlist_item.dart';

class MemberPlaylistScreen extends StatefulWidget {
  const MemberPlaylistScreen({
    super.key,
    required this.memberId,
  });

  final int memberId;

  @override
  State<MemberPlaylistScreen> createState() => _MemberPlaylistScreenState();
}

class _MemberPlaylistScreenState extends State<MemberPlaylistScreen> {


  late PlayListProv playListProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool>? _getMemberPlayListFuture;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMemberPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getMemberPagePlayList(widget.memberId,0, 20);
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

    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black,
      child: FutureBuilder<bool>(
          future: _getMemberPlayListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            } else {


              PlaylistList playListList = playListProv.playlists;
              List<PlayListInfoModel> memberPlayList = playListProv.playlists.playList;

              return NotificationListener <ScrollNotification>(
                onNotification: (notification) {

                  if (playListList.memberPagePlayListTotalCount! > memberPlayList.length) {
                    if (comnLoadProv.shouldLoadMoreData(notification)) {
                      comnLoadProv.loadMoreData(playListProv, "MemberPagePlayList", memberPlayList.length , memberId: widget.memberId);
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
                        title: "PlayLists",
                        isNotification : false,
                        isEditBtn: false,
                        isAddTrackBtn : false,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            if (memberPlayList.length != 0) ...[

                              SizedBox(
                                height: 8,
                              ),

                              for(int i = 0; i < memberPlayList.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(left: 15,bottom: 5),
                                  child: PlaylistItem(playList: memberPlayList[i],isAlbum: false),
                                ),

                              SizedBox(
                                height: 8,
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
