import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';

class MyAlbumScreen extends StatefulWidget {
  const MyAlbumScreen({
    super.key,
    required this.adminId,
  });

  final int? adminId;

  @override
  State<MyAlbumScreen> createState() => _MyAlbumScreenState();
}

class _MyAlbumScreenState extends State<MyAlbumScreen> {
  late PlaylistList playListModel;

  late Future<bool> _getPlayListFuture;
  bool isApiCall = false;
  int offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getPlayList(0, 0, true);
  }

  bool _shouldLoadMoreData(ScrollNotification notification) {
    return notification is ScrollUpdateNotification &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  void _setApiCallStatus(bool status) {
    setState(() {
      isApiCall = status;
    });
  }

  void _resetApiCallStatus() {
    setState(() {
      isApiCall = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    PlayListProv playListProv = Provider.of<PlayListProv>(context);

    Future<void> _loadMoreData() async {
      if (!isApiCall) {
        _setApiCallStatus(true);
        offset = offset + 20;
        await Future.delayed(Duration(seconds: 3));  // API 호출 후 지연 처리
        await playListProv.getPlayList(0, offset, true);
        _setApiCallStatus(false);
      }
    }

    return Scaffold(
      body: Container(
        height: 100.h,
        color: Color(0xff1c1c1c),
        child: FutureBuilder<bool>(
          future: _getPlayListFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            }

            playListModel = playListProv.playlistList;

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (playListModel.totalCount! > playListModel.playList.length) {
                  if (_shouldLoadMoreData(notification)) {
                    _loadMoreData();
                  }
                } else {
                  _resetApiCallStatus();
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
                            title: "내 앨범",
                            isNotification : false,
                            isEditBtn: false,
                            isAddPlayListBtn : false,
                            isAddAlbumBtn : true,
                            isAddTrackBtn : false,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          PlayListSquareItem(
                            playList: playListModel.playList,
                          ),
                        ],
                      ),
                    ),

                    CustomProgressIndicator(isApiCall: isApiCall),
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
