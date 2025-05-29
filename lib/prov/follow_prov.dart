import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/follow/follow_model.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class FollowProv extends ChangeNotifier{

  FollowModel followModel = FollowModel();

  void notify() {
    notifyListeners();
  }

  void clear() {
    followModel = FollowModel();
  }

  Future<bool> getFollow() async {

    String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getFollow?loginMemberId=${loginMemberId}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {

        followModel = FollowModel();
        followModel.followerList = [];
        followModel.followingList = [];

        //검색 api에도 필요함
        // 공통을 만들어야하나

        for (var followerData in ComnUtils.extractValue(response.body, 'followerList')) {

          FollowInfoModel followInfoModel = FollowInfoModel.fromJson(followerData);

          if (followInfoModel.isFollowedCd == 1 || followInfoModel.isFollowedCd == 3) {
            followInfoModel.isFollow = true;
          }

          followModel.followerList?.add(followInfoModel);
        }

        for (var followingData in ComnUtils.extractValue(response.body, 'followingList')) {

          FollowInfoModel followInfoModel = FollowInfoModel.fromJson(followingData);

          if (followInfoModel.isFollowedCd == 1 || followInfoModel.isFollowedCd == 3) {
            followInfoModel.isFollow = true;
          }

          followModel.followingList?.add(followInfoModel);
        }

        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> setFollow(followerId,followingId) async {

    final url = '/api/setFollow';

    try {
      http.Response response = await ComnUtils.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json'
          },
           body : {
            'followerId': followerId,
            'followingId': followingId,
          },
      );

      if (response.statusCode == 200) {
        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }
}