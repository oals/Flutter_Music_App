import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/home/home_model.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/utils/helpers.dart';

class HomeProv extends ChangeNotifier {
  HomeModel model = HomeModel();

  void notify() {
    notifyListeners();
  }

  Future<bool> firstLoad() async {

    final loginMemberId = await Helpers.getMemberId();

    model.homeCategory = 0;
    print('카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요카테고리수정필요');

    final url= '/api/firstLoad?loginMemberId=${loginMemberId}';

    try {

      dynamic response = await Helpers.apiCall(url,method: 'GET');

      if (response['status'] == '200') {

        model.trendingTrackList = [];
        model.randomMemberList = [];
        model.popularPlayList = [];
        model.followMemberTrackList = [];
        model.likedTrackList = [];

        for(var item in response['trendingTrackList']){
          model.trendingTrackList.add(Track.fromJson(item));
        }
        for(var item in response['randomMemberList']){
          model.randomMemberList.add(MemberModel.fromJson(item));
        }
        for(var item in response['popularPlayList']){
          model.popularPlayList.add(PlayListModel.fromJson(item));
        }
        for(var item in response['followMemberTrackList']){
          model.followMemberTrackList.add(Track.fromJson(item));
        }
        for(var item in response['likedTrackList']){
          model.likedTrackList.add(Track.fromJson(item));
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
}
