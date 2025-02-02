import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/utils/helpers.dart';


class SearchProv extends ChangeNotifier {
  SearchModel model = SearchModel();
  SearchModel moreModel = SearchModel();
  List<SearchHistoryModel> searchHistoryModel = [];
  List<String> popularTrackHistory = [];

  void notify() {
    notifyListeners();
  }


  Future<bool> fnInit() async {

    final String memberId = await Helpers.getMemberId();
    final url = 'getSearchInit?memberId=${memberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        searchHistoryModel = [];
        popularTrackHistory = [];

        for (var item in response['searchHistory']) {
          searchHistoryModel.add(SearchHistoryModel.fromJson(item));
        }
        for (var item in response['popularTrackHistory']) {
          popularTrackHistory.add(item);
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



  Future<bool> searchMore(int moreId, String searchText,int listIndex) async {

    final String memberId = await Helpers.getMemberId();
    
    final url = 'getSearchMore?'
        'memberId=${memberId}&'
        'moreId=${moreId}&searchText=${searchText}&'
        'listIndex=${listIndex}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {
        if (listIndex == 0) {
          moreModel.trackList = [];
          moreModel.memberList = [];
          moreModel.playListList = [];
        }

        if(moreId == 1) {
          for (var item in response['memberList']) {
            moreModel.memberList.add(FollowInfoModel.fromJson(item));
          }
          moreModel.totalCount = response['totalCount'];
        } else if (moreId == 2) {
          for (var item in response['playListList']) {
            moreModel.playListList.add(PlayListModel.fromJson(item));
          }
          moreModel.totalCount = response['totalCount'];
        } else if (moreId == 3) {
          for (var item in response['trackList']) {
            model.trackList.add(Track.fromJson(item));
          }
        }
        moreModel.status = response['status'];
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



  Future<bool> searchTrack(String searchText,listIndex) async {

    final String memberId = await Helpers.getMemberId();
    final url = 'getSearchTrack?memberId=${memberId}&searchText=$searchText&listIndex=$listIndex';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        model.trackList = [];
        model.memberList = [];
        model.playListList = [];

        for (var item in response['trackList']) {
          model.trackList.add(Track.fromJson(item));
        }

        for (var item in response['memberList']) {
          model.memberList.add(FollowInfoModel.fromJson(item));
        }
        model.memberListCnt = response['memberListCnt'];

        for (var item in response['playListList']) {
          model.playListList.add(PlayListModel.fromJson(item));
        }
        model.playListListCnt = response['playListListCnt'];

        model.status = response['status'];
        model.totalCount = response['totalCount'];
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
