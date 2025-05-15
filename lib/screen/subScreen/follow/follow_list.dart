import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/follow/follow_model.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/screen/subScreen/follow/follow_item.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class FollowList extends StatefulWidget {
  const FollowList({
    super.key,
    
    required this.followList,
    required this.setFollow,
    required this.isFollowingItem,
  });

  
  final List<FollowInfoModel>? followList;
  final Function setFollow;
  final bool isFollowingItem;

  @override
  State<FollowList> createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  late List<FollowInfoModel>? filteredFollowList;

  @override
  void initState() {
    // TODO: implement initState
    filteredFollowList = widget.followList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        for (int i = 0; i < filteredFollowList!.length; i++)
          Container(
              padding: EdgeInsets.all(10),
              child: FollowItem(
                  filteredFollowItem: filteredFollowList![i],
                  setFollow: widget.setFollow,
                  isFollowingItem: widget.isFollowingItem,
                  isSearch: false,
              ),
          ),


        if (filteredFollowList!.length == 0)
          Container(
            height: 60.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Empty',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
