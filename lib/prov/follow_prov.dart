
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/follow/follow_model.dart';
import 'package:skrrskrr/utils/helpers.dart';

class FollowProv extends ChangeNotifier{

  FollowModel model = FollowModel();
  bool isFirstLoad = true;

  void notify() {
    notifyListeners();
  }

  Future<bool> getFollow() async {
    String memberId = await Helpers.getMemberId();
    final url= '/api/getFollow?memberId=${memberId}';

    try {
      // POST 요청
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json'
        }, // JSON 형태로 전송
      );

      if (response['status'] == '200') {
        // 성공적으로 데이터를 가져옴
        
        model = FollowModel();
        model.followerList = [];
        model.followingList = [];

        for(var followerData in response['followerList']) {
          model.followerList?.add(FollowInfoModel.fromJson(followerData));
        }

        for(var followingData in response['followingList']) {
          model.followingList?.add(FollowInfoModel.fromJson(followingData));
        }
        print('$url - Successful');
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }


  Future<bool> setFollow(followerId,followingId) async {

    final url= '/api/setFollow';
    try {

      // POST 요청
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
           body : {
            'followerId': followerId,
            'followingId': followingId,
          },
      );

      if (response['status'] == '200') {
        // 성공적으로 데이터를 가져옴
        print('$url - Successful');
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }

  }

}