import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/utils/helpers.dart';

class MemberProv with ChangeNotifier {

  MemberModel model = MemberModel();
  List<MemberModel> memberModelList = [];

  void notify() {
    notifyListeners();
  }

  void clear() {
    model = MemberModel();
  }


  Future<void> fnMemberInfoUpdate({memberNickName,memberInfo}) async {
    final url= '/api/setMemberInfoUpdate';
    try{
      final String loginMemberId = await Helpers.getMemberId();
      dynamic response = await Helpers.apiCall(
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

      if (response['status'] == '200') {
        print('$url - Successful');
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
    }
  }



  Future<bool> getHomeInitMember() async {

    final loginMemberId = await Helpers.getMemberId();
    final url= '/api/getHomeInitMember?loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
      );

      print(response);
      if (response['status'] == '200') {

        memberModelList = [];

        for (var item in response['randomMemberList']){
          memberModelList.add(MemberModel.fromJson(item));
        }

        print('$url - Successful');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;

    }
  }

  Future<bool> getMemberInfo(String memberEmail) async {

    final String? deviceToken = await FcmNotifications.getMyDeviceToken();
    final url= '/api/getMemberInfo?memberEmail=${memberEmail}&deviceToken=${deviceToken}';

    try {
      final response = await Helpers.apiCall(
        url,
      );

      print(response);
      if (response['status'] == '200') {
        model = MemberModel.fromJson(response['member']);
        await saveMemberData();
        print('$url - Successful');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
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
    final url= '/api/getMemberPageInfo?memberId=${memberId}&loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
      );

      if (response['status'] == '200') {

        model = MemberModel();
        model.playListList = [];
        model.popularTrackList = [];
        model.allTrackList = [];

        List<PlayListInfoModel>  playListList = [];
        List<Track> popularTrackList = [];
        List<Track> allTrackList = [];

        model = MemberModel.fromJson(response['memberDTO']);

        for (var item in response['playListList']) {
          PlayListInfoModel playList = PlayListInfoModel.fromJson(item);
          playListList.add(playList);
        }

        for(var item in response['popularTrackList']) {
          Track track = Track.fromJson(item);
          popularTrackList.add(track);
        }

        for(var item in response['allTrackList']) {
          Track track = Track.fromJson(item);
          allTrackList.add(track);
        }


        model.playListListCnt = response['playListListCnt'];
        model.allTrackListCnt = response['allTrackListCnt'];
        model.playListList = playListList;
        model.popularTrackList = popularTrackList;
        model.allTrackList = allTrackList;

        print('$url - Successful');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }
  }

}
