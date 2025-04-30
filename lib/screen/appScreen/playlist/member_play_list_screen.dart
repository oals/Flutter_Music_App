import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_lists_list_item.dart';

class MemberPlayListScreen extends StatefulWidget {
  const MemberPlayListScreen({
    super.key,
    required this.memberId,
  });

  final int memberId;

  @override
  State<MemberPlayListScreen> createState() => _MemberPlayListScreenState();
}

class _MemberPlayListScreenState extends State<MemberPlayListScreen> {


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
          future: _getMemberPlayListFuture, // 비동기 메소드 호출
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: (){
                                  GoRouter.of(context).pop();
                                },
                                child: Icon(Icons.arrow_back_rounded,color: Colors.white,)),
                            SizedBox(width: 5,),
                            Text(
                              'PlayLists' ,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (memberPlayList.length != 0) ...[

                        SizedBox(
                          height: 8,
                        ),

                        for(int i = 0; i < memberPlayList.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(left: 15,bottom: 5),
                            child: PlayListsListItem(playList: memberPlayList[i],isAlbum: false),
                          ),

                        SizedBox(
                          height: 8,
                        ),
                        CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall)


                      ],
                    ],
                  ),
                ),
              );
            }
          }
      ),
    );
  }
}
