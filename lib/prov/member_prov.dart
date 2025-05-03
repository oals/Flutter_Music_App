import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/member/member_model_list.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/utils/helpers.dart';
import 'package:http/http.dart' as http;

class MemberProv with ChangeNotifier {

  MemberModel model = MemberModel();
  List<FollowInfoModel> recommendMemberList = [];
  MemberModelList searchMemberModelList = MemberModelList();

  void notify() {
    notifyListeners();
  }

  void clear() {
    model = MemberModel();
  }

  Future<void> fnMemberInfoUpdate({memberNickName,memberInfo}) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setMemberInfoUpdate';

    try{
      http.Response response = await Helpers.apiCall(
            url,
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: {
              'loginMemberId' : loginMemberId,
              'memberNickName' : memberNickName,
              'memberInfo' : memberInfo
            }
          );

      if (response.statusCode == 200) {
        print('$url - Successful');
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
    }
  }

  Future<bool> getSearchMember(String searchText, int offset, int limit) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getSearchMember?loginMemberId=${loginMemberId}&searchText=$searchText&limit=${limit}&offset=$offset';

    try {
      http.Response response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        if (offset == 0) {
          searchMemberModelList = MemberModelList();
        }

        for (var followerData in Helpers.extractValue(response.body, 'followMemberList')) {

          FollowInfoModel followInfoModel = FollowInfoModel.fromJson(followerData);

          if (followInfoModel.isFollowedCd == 1 || followInfoModel.isFollowedCd == 3) {
            followInfoModel.isFollow = true;
          }

          searchMemberModelList.memberList.add(followInfoModel);
        }

        searchMemberModelList.memberListCnt = Helpers.extractValue(response.body, 'totalCount');

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

  Future<bool> getMemberInfo(String memberEmail) async {

    final String? deviceToken = await FcmNotifications.getMyDeviceToken();
    final url = '/api/getMemberInfo?memberEmail=${memberEmail}&deviceToken=${deviceToken}';

    try {
      http.Response response = await Helpers.apiCall(
        url,
      );

      if (response.statusCode == 200) {

        model = MemberModel.fromJson(Helpers.extractValue(response.body, 'member'));

        await saveMemberData();

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

  Future<void> saveMemberData() async {
    // SharedPreferences에 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('memberEmail', model.memberEmail.toString());
    await prefs.setString('memberImagePath', model.memberImagePath.toString());
    await prefs.setString('memberNickName', model.memberNickName.toString());
    await prefs.setString('memberId', model.memberId.toString());
    notifyListeners(); // 상태 변경 알림
  }

  //유저 페이지 접근
  Future<bool> getMemberPageInfo(int memberId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getMemberPageInfo?memberId=${memberId}&loginMemberId=${loginMemberId}';

    try {
      http.Response response = await Helpers.apiCall(
        url,
      );

      if (response.statusCode == 200) {

        model = MemberModel();

        model = MemberModel.fromJson(Helpers.extractValue(response.body, 'member'));

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