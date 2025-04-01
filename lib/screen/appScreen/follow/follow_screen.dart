import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/follow/follow_model.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/follow/follow_list.dart';


class FollowScreen extends StatefulWidget {
  const FollowScreen({
    super.key,
    
  });

  

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late FollowProv followProv;
  late Future<bool> _getFollowListInitFuture;

  String titleText = "Following";

  @override
  void initState() {
    super.initState();
    _getFollowListInitFuture = Provider.of<FollowProv>(context, listen: false).getFollow();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setFollow(int? followerId, int? followingId) async {
    await followProv.setFollow(followerId, followingId);
  }

  @override
  Widget build(BuildContext context) {
    followProv = Provider.of<FollowProv>(context);

    print('빌드1');
    return Scaffold(
      body: Container(
        color: Color(0xff000000),
        width : 100.w,
        height: 120.h,
        child: FutureBuilder<bool>(
          future: _getFollowListInitFuture,
          // 팔로우 및 팔로잉 데이터를 비동기적으로 가져오는 함수
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {

              FollowModel followModel = followProv.followModel;


              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomAppbar(
                    fnBackBtncallBack: ()=>{GoRouter.of(context).pop()},
                    fnUpdtBtncallBack:()=>{},
                      title: titleText,
                      isNotification: true,
                    isEditBtn: false,
                    isAddPlayListBtn : false,
                    isAddTrackBtn : false,
                    isAddAlbumBtn : false,
                  ),
                  SizedBox(height: 10,),

                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    // 선택된 탭의 텍스트 색상
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: Colors.black,  // 기본 회색 선을 없애기 위해 투명으로 설정
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,  // 선의 두께
                          color: Colors.white,  // 선의 색상
                        ),
                      ),
                    ),
                    isScrollable: false,    // 탭이 스크롤 가능하도록 설정 (선택 사항)
                    padding: EdgeInsets.zero,  // TabBar 내부의 패딩을 0으로 설정
                    tabs: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                                '${followModel.followingList?.length} 팔로잉',
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                            ),),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                                '${followModel.followerList?.length} 팔로워',
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [

                        // 팔로잉 목록
                        SingleChildScrollView(
                          child: FollowList(

                            setFollow: setFollow,
                            followList: followModel.followingList,
                            isFollowingItem: true,
                          ),
                        ),

                        // 팔로워 목록
                        SingleChildScrollView(
                          child: FollowList(

                            setFollow: setFollow,
                            followList: followModel.followerList,
                            isFollowingItem: false,
                          ),
                        ),


                      ],
                    ),
                  ),

                ],
              );
            }
          },
        ),
      ),
    );
  }
}
