import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/follow/follow_model.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/follow/follow_list.dart';

class MemberFollowScreen extends StatefulWidget {
  const MemberFollowScreen({
    super.key,
  });

  @override
  State<MemberFollowScreen> createState() => _MemberFollowScreenState();
}

class _MemberFollowScreenState extends State<MemberFollowScreen>
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

    return Scaffold(
      body: Container(
        color: Color(0xff000000),
        width : 100.w,
        height: 120.h,
        child: FutureBuilder<bool>(
          future: _getFollowListInitFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else {

              FollowModel followModel = followProv.followModel;


              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomAppbar(
                    fnBackBtnCallBack: ()=>{GoRouter.of(context).pop()},
                    fnUpdateBtnCallBack:()=>{},
                      title: titleText,
                      isNotification: true,
                    isEditBtn: false,
                    isAddTrackBtn : false,
                  ),
                  SizedBox(height: 10,),

                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(
                          width: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    isScrollable: false,
                    padding: EdgeInsets.zero,
                    tabs: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                                '${followModel.followingList?.length} following',
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                            ),),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: Text(
                                '${followModel.followerList?.length} follower',
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
