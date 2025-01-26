import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/utils/helpers.dart';

class MemberProv with ChangeNotifier {

  MemberModel model = MemberModel();


  void notify() {
    notifyListeners();
  }

  void clear() {
    model = MemberModel();
  }



  Future<void> fnMemberInfoUpdate({memberNickName,memberInfo}) async {

    try{
      final url = 'setMemberInfoUpdate';
      final String memberId = await Helpers.getMemberId();

      dynamic response = await Helpers.apiCall(
            url,
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: {
              'memberId' : memberId,
              'memberNickName' : memberNickName,
              'memberInfo' : memberInfo
            }
          );

      if (response != null) {


      }


    } catch (error) {
      debugPrintStack();
      print(error);
    }


  }


  Future<void> getMemberInfo(String memberEmail) async {

    print('getMemberInfo');
    final String? deviceToken = await FcmNotifications.getMyDeviceToken();
    final url = 'getMemberInfo?memberEmail=${memberEmail}&deviceToken=${deviceToken}';

    try {
      final response = await Helpers.apiCall(
        url,
      );

      if (response != null) {
        print(response);
        model = MemberModel.fromJson(response['member']);
        await saveMemberData();

      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error,stackTrace) {
      // 오류 처리
      print('멤버정보 조회중 오류 발생');
      print('Error: ${error}');
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
    final url = 'getMemberPageInfo?memberId=${memberId}&loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
      );

      if (response != null) {

        model = MemberModel();
        model.playListDTO = [];
        model.popularTrackList = [];
        model.allTrackList = [];

        List<PlayListInfoModel> playList = [];
        List<Track> popularTrackList = [];
        List<Track> allTrackList = [];

        model = MemberModel.fromJson(response['memberDTO']);
        print(model.toJson());

        for (var item in response['playListDTO']) {
          PlayListInfoModel playListInfoModel = PlayListInfoModel.fromJson(item);
          playList.add(playListInfoModel);
        }

        for(var item in response['popularTrackList']) {
          Track track = Track.fromJson(item);
          popularTrackList.add(track);
        }

        for(var item in response['allTrackList']) {
          Track track = Track.fromJson(item);
          allTrackList.add(track);
        }

        model.playListDTO = playList;
        model.popularTrackList = popularTrackList;
        model.allTrackList = allTrackList;



        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('마이페이지 조회 중 오류 발생');
      print('Error: ${error}');
      return false;
    }
  }





}
