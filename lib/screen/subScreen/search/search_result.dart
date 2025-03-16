import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/search_prov.dart';

import 'package:skrrskrr/screen/subScreen/follow/follow_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';
import 'package:skrrskrr/utils/helpers.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({
    super.key,
    required this.searchModel,
  });


  final SearchModel searchModel;
  

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  late SearchProv searchProv;

  @override
  void dispose() {
    // TODO: implement dispose
    searchProv.clear();
    // searchProv.listIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FollowProv followProv = Provider.of<FollowProv>(context);
    searchProv = Provider.of<SearchProv>(context);

    void setFollow(int? followerId, int? followingId) async {
      await followProv.setFollow(followerId, followingId);
    }

    return Container(
      height: 67.h,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (widget.searchModel.totalCount! > widget.searchModel.trackList.length) {
            if (searchProv.shouldLoadMoreData(notification)) {
              searchProv.loadMoreData(3);
            }
          } else {
            searchProv.resetApiCallStatus();
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.searchModel.memberList.length != 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '아티스트',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.searchModel.memberListCnt! > 4)
                      GestureDetector(
                        onTap: () {
                          print('검색어 테스트');
                          print(widget.searchModel.searchText);
                          GoRouter.of(context).push('/more/${1}/${widget.searchModel.searchText}/${widget.searchModel.memberListCnt}');

                          },
                        child: Text(
                          'more',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                for (int i = 0; i < widget.searchModel.memberList.length; i++) ...[
                  FollowItem(
                    filteredFollowItem: widget.searchModel.memberList[i],
                    setFollow: setFollow,
                    isFollowingItem: false,
                    isSearch: true,
                  ),
                ],
                SizedBox(
                  height: 8,
                ),
              ],
              if (widget.searchModel.playListList.length != 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '플레이리스트',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.searchModel.playListListCnt! > 8)
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push('/more/${2}/${widget.searchModel.searchText}/${widget.searchModel.playListListCnt}');
                        },
                        child: Text(
                          'more',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    return true;
                  },
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: PlayListSquareItem(

                      playList: widget.searchModel.playListList,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
              if (widget.searchModel.trackList.length != 0) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '트랙',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                for (int i = 0;
                    i < widget.searchModel.trackList.length;
                    i++) ...[
                  SizedBox(
                    height: 16,
                  ),
                  TrackListItem(
                    trackItem: widget.searchModel.trackList[i],
                    

                  )
                ],
              ],
              if (searchProv.isApiCall)...[
                SizedBox(height: 10,),
                CircularProgressIndicator(
                  color: Color(0xffff0000),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
