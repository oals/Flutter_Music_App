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

class SearchPlayListScreen extends StatefulWidget {
  const SearchPlayListScreen({
    super.key,
    required this.searchText,
  });

  final String searchText;

  @override
  State<SearchPlayListScreen> createState() => _SearchPlayListScreenState();
}

class _SearchPlayListScreenState extends State<SearchPlayListScreen> {
  late PlayListProv playListProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool>? _getSearchPlayListFuture;
  List<PlayListInfoModel> searchPlayList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSearchPlayListFuture = Provider.of<PlayListProv>(context, listen: false).getSearchPlayList(widget.searchText,0,20);
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
          future: _getSearchPlayListFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
            } else {


              PlaylistList playListList = playListProv.playlists;
              List<PlayListInfoModel> searchPlayList = playListList.playList;

              return NotificationListener <ScrollNotification>(
                onNotification: (notification) {
                  if (playListList.searchPlayListTotalCount! > searchPlayList.length) {
                    if (comnLoadProv.shouldLoadMoreData(notification)) {
                      comnLoadProv.loadMoreData(playListProv, "SearchPlayList", searchPlayList.length , searchText: widget.searchText);
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

                      if (searchPlayList.length != 0) ...[
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for(int i = 0 ; i < searchPlayList.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, bottom: 5.0),
                                  child: PlayListsListItem(playList: searchPlayList[i],isAlbum: false),
                                ),

                            ],
                          ),
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
