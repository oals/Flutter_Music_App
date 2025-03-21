import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/more_prov.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/screen/subScreen/follow/follow_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({
    super.key,
    required this.moreId,
    required this.searchText,
    required this.memberId,
    required this.totalCount,
  });

  final int? moreId;
  final String? searchText;
  final String? memberId;
  final int? totalCount;

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {


  late Future<bool> _getMoreInfoInitFuture;
  late MoreProv moreProv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMoreInfoInitFuture = Provider.of<MoreProv>(context,listen: false).searchMore(widget.moreId!, widget.searchText, widget.memberId,0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    moreProv.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    moreProv = Provider.of<MoreProv>(context);
    FollowProv followProv = Provider.of<FollowProv>(context);

    void setFollow(int? followerId, int? followingId) async {
      await followProv.setFollow(followerId, followingId);
    }

    return Container(
      padding: EdgeInsets.all(5),
      color: Color(0xff1c1c1c),
      child: FutureBuilder<bool>(
        future: _getMoreInfoInitFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          SearchModel searchMoreModel = moreProv.moreModel;
          moreProv.moreModel.searchText = widget.searchText;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      widget.moreId == 1 ? '아티스트' : widget.moreId == 2 ? '플레이리스트' : widget.moreId == 4 ? '플레이리스트': '트랙',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),


              if (widget.moreId == 1) ...[
                Container(
                  height: 72.h,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (widget.totalCount! > searchMoreModel.memberList.length) {
                        if (moreProv.shouldLoadMoreData(notification)) {
                          moreProv.loadMoreData(widget.moreId!,widget.searchText,widget.memberId);
                        }
                      } else {
                        moreProv.resetApiCallStatus();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          for (int i = 0; i < searchMoreModel.memberList.length; i++) ...[
                            FollowItem(
                              filteredFollowItem: searchMoreModel.memberList[i],
                              setFollow: setFollow,
                              isFollowingItem: false,
                              isSearch: true,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              if (widget.moreId == 2 || widget.moreId == 4) ...[
                SizedBox(height: 15,),
                Container(
                  height: 72.h,
                  child: NotificationListener <ScrollNotification>(
                    onNotification: (notification) {
                      if (widget.totalCount! > searchMoreModel.playListList.length) {
                        if (moreProv.shouldLoadMoreData(notification)) {
                          moreProv.loadMoreData(widget.moreId!,widget.searchText,widget.memberId);
                        }
                      } else {
                        moreProv.resetApiCallStatus();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PlayListSquareItem(
                            playList: searchMoreModel.playListList,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
              ],

              if (widget.moreId == 3 || widget.moreId == 5) ...[
                Container(
                  height: 72.h,
                  child: NotificationListener <ScrollNotification>(
                    onNotification: (notification) {
                      if (widget.totalCount! > searchMoreModel.trackList.length) {
                        if (moreProv.shouldLoadMoreData(notification)) {
                          moreProv.loadMoreData(widget.moreId!,widget.searchText,widget.memberId);
                        }
                      } else {
                        moreProv.resetApiCallStatus();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < searchMoreModel.trackList.length; i++) ...[
                            SizedBox(
                              height: 16,
                            ),
                            TrackListItem(
                              trackItem: searchMoreModel.trackList[i],
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

              ],

              if (moreProv.isApiCall)...[
                SizedBox(height: 10,),
                CircularProgressIndicator(
                  color: Color(0xffff0000),
                ),
              ],

            ],
          );
        },
      ),
    );

  }
}
