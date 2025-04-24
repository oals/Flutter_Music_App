
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/follow/follow_model.dart';
import 'package:skrrskrr/utils/helpers.dart';

class FollowProv extends ChangeNotifier{

  FollowModel followModel = FollowModel();

  void notify() {
    notifyListeners();
  }

  Future<bool> getFollow() async {

    String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getFollow?loginMemberId=${loginMemberId}';

    try {
      http.Response response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {

        followModel = FollowModel();
        followModel.followerList = [];
        followModel.followingList = [];

        for (var followerData in Helpers.extractValue(response.body, 'followerList')) {
          followModel.followerList?.add(FollowInfoModel.fromJson(followerData));
        }

        for (var followingData in Helpers.extractValue(response.body, 'followingList')) {
          followModel.followingList?.add(FollowInfoModel.fromJson(followingData));
        }

        print('$url - Successful');
        return true;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
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
      http.Response response = await Helpers.apiCall(
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
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }
}