import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/member/member_model_list.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/comn/messages/empty_message_item.dart';
import 'package:skrrskrr/screen/subScreen/follow/follow_item.dart';

class SearchMemberScreen extends StatefulWidget {
  const SearchMemberScreen({
    super.key,
    required this.searchText,
  });

  final String searchText;


  @override
  State<SearchMemberScreen> createState() => _SearchMemberScreenState();
}

class _SearchMemberScreenState extends State<SearchMemberScreen> {

  late MemberProv memberProv;
  late FollowProv followProv;
  late ComnLoadProv comnLoadProv;
  late Future<bool>? _getSearchMemberFuture;

  @override
  void initState() {
    super.initState();
    _getSearchMemberFuture = Provider.of<MemberProv>(context, listen: false).getSearchMember(widget.searchText,0, 20);
  }

  @override
  void dispose() {
    comnLoadProv.clear();
    super.dispose();
  }

  void setFollow(int? followerId, int? followingId) async {
    await followProv.setFollow(followerId, followingId);
  }

  @override
  Widget build(BuildContext context) {
    memberProv = Provider.of<MemberProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);
    followProv = Provider.of<FollowProv>(context);

    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.black,
      child: FutureBuilder<bool>(
          future: _getSearchMemberFuture, // 비동기 메소드 호출
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomProgressIndicatorItem());
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else {

              MemberModelList memberModelList = memberProv.searchMemberModelList;

              return NotificationListener <ScrollNotification>(
                onNotification: (notification) {
                  if (memberProv.searchMemberModelList.memberListCnt! > memberModelList.memberList.length) {
                    if (comnLoadProv.shouldLoadMoreData(notification)) {
                      comnLoadProv.loadMoreData(memberProv, "SearchMember", memberModelList.memberList.length , searchText: widget.searchText);
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
                        title: "Users",
                        isNotification : false,
                        isEditBtn: false,
                        isAddTrackBtn : false,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top : 100.0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [

                              if (memberModelList.memberList.length == 0)
                                EmptyMessageItem(paddingHeight: 30.h),

                              if (memberModelList.memberList.length != 0) ...[

                                SizedBox(
                                  height: 8,
                                ),
                                for (int i = 0; i < memberModelList.memberList.length; i++) ...[
                                  FollowItem(
                                    filteredFollowItem: memberModelList.memberList[i],
                                    setFollow: setFollow,
                                    isFollowingItem: false,
                                    isSearch: true,
                                  ),
                                ],
                                SizedBox(
                                  height: 8,
                                ),
                                CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall)


                              ],
                            ],
                          ),
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
