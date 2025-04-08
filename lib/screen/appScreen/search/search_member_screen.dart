import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/member/member_model_list.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
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
    // TODO: implement initState
    super.initState();
    _getSearchMemberFuture = Provider.of<MemberProv>(context, listen: false).getSearchMember(widget.searchText,0, 20);
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('데이터가 없습니다.'));
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                'Users' ,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

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
              );
            }
          }
      ),
    );
  }
}
