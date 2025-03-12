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
  List<SearchHistoryModel> searchHistoryModel = [];
  List<String> popularTrackHistory = [];
  bool isApiCall = false;
  int listIndex = 0;

  void notify() {
    notifyListeners();
  }

  void clear() {
    model = SearchModel();
    searchHistoryModel = [];
    popularTrackHistory = [];
    isApiCall = false;
    listIndex = 0;
  }

  Future<void> loadMoreData(int moreId) async {
    if (!isApiCall) {
      setApiCallStatus(true);
      listIndex += 20;
      await Future.delayed(Duration(seconds: 3));  // API 호출 후 지연 처리
      await searchMore(moreId, model.searchText!, listIndex);
      setApiCallStatus(false);
    }
  }

  bool shouldLoadMoreData(ScrollNotification notification) {
    return notification is ScrollUpdateNotification &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  void setApiCallStatus(bool status) {
    isApiCall = status;
    notify();
  }

  void resetApiCallStatus() {
    isApiCall = false;
    notify();
  }




  Future<bool> fnSearchInit() async {

    final String memberId = await Helpers.getMemberId();
    final url= '/api/getSearchInit?memberId=${memberId}';

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
    
    final url= '/api/getSearchMore?'
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
          model.trackList = [];
          model.memberList = [];
          model.playListList = [];
        }

        if(moreId == 1) {
          for (var item in response['memberList']) {
            model.memberList.add(FollowInfoModel.fromJson(item));
          }
          model.totalCount = response['totalCount'];
        } else if (moreId == 2) {
          for (var item in response['playListList']) {
            model.playListList.add(PlayListModel.fromJson(item));
          }
          model.totalCount = response['totalCount'];
        } else if (moreId == 3) {
          for (var item in response['trackList']) {
            model.trackList.add(Track.fromJson(item));
          }
        }
        model.status = response['status'];
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
    final url= '/api/getSearchTrack?memberId=${memberId}&searchText=$searchText&listIndex=$listIndex';

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
