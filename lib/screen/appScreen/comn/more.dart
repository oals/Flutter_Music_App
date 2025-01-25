import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/screen/subScreen/follow/follow_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';
import 'package:skrrskrr/screen/subScreen/playlist/play_list_square_item.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({
    super.key,
    required this.moreId,
    
    
    required this.searchText,
    required this.totalCount,
  });


  final int? moreId;
  
  
  final String searchText;
  final int? totalCount;

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  bool isLoading = false;
  bool isApiCall = false;
  int listIndex = 0;


  @override
  Widget build(BuildContext context) {

    print('more build');

    FollowProv followProv = Provider.of<FollowProv>(context);

    void setFollow(int? followerId, int? followingId) async {
      await followProv.setFollow(followerId, followingId);
    }


    SearchProv searchProv = Provider.of<SearchProv>(context);

    print('전달된 길이값');
    print(widget.totalCount);

    return Container(
      padding: EdgeInsets.all(5),
      color: Color(0xff1c1c1c),
      child: FutureBuilder<bool>(
        future: !isLoading ? searchProv.searchMore(widget.moreId!, widget.searchText,0) : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          isLoading = true;
          SearchModel searchModel = searchProv.moreModel;
          searchModel.searchText = widget.searchText;


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
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_rounded,color: Colors.white,)),
                    SizedBox(width: 5,),
                    Text(
                      widget.moreId == 1 ? '아티스트' : widget.moreId == 2 ? '플레이리스트' :'test',
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
                      if(widget.totalCount! > searchModel.memberList.length){
                        // 스크롤이 끝에 도달했을 때
                        if (notification is ScrollUpdateNotification && notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                          if(!isApiCall) {
                            Future(() async {
                              setState(() {
                                isApiCall = true;
                              });
                              listIndex = listIndex + 20;
                              await searchProv.searchMore(widget.moreId!, searchModel.searchText!,listIndex);
                              await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                isApiCall = false;
                              });
                            });
                          }
                          return true;
                        }
                      } else {
                        isApiCall = true;
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          for (int i = 0; i < searchModel.memberList.length; i++) ...[
                            FollowItem(
                              
                              filteredFollowItem: searchModel.memberList[i],
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
              if (widget.moreId == 2) ...[
                SizedBox(height: 15,),
                Container(
                  height: 72.h,
                  child: NotificationListener(
                    onNotification: (notification) {
                      if(widget.totalCount! > searchModel.playListList.length){
                        // 스크롤이 끝에 도달했을 때
                        if (notification is ScrollUpdateNotification && notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                          if(!isApiCall) {
                            Future(() async {
                              setState(() {
                                isApiCall = true;
                              });
                              listIndex = listIndex + 20;
                              await searchProv.searchMore(widget.moreId!, searchModel.searchText!,listIndex);
                              await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                isApiCall = false;
                              });
                            });
                          }
                          return true;
                        }
                      } else {
                        isApiCall = true;
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PlayListSquareItem(
                            
                            playList: searchModel.playListList,
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

              if (widget.moreId == 3) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '트랙',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'more',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                for (int i = 0; i < searchModel.trackList.length; i++) ...[
                  SizedBox(
                    height: 16,
                  ),
                  TrackListItem(
                    trackItem: searchModel.trackList[i],
                    
                    
                  )
                ],
              ],

              if (isApiCall)
                CircularProgressIndicator(
                  color: Color(0xffff0000),
                )

            ],
          );
        },
      ),
    );

  }
}
