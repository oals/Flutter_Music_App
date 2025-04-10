import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';


class SearchProv extends ChangeNotifier {
  SearchModel model = SearchModel();

  List<SearchHistoryModel> searchHistoryModel = [];
  List<String> recentListenTrackHistory = [];

  void notify() {
    notifyListeners();
  }

  void clear() {
    model = SearchModel();
    searchHistoryModel = [];
    recentListenTrackHistory = [];
  }


  Future<bool> fnSearchTextHistory() async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getSearchTextHistory?loginMemberId=${loginMemberId}&limit=${30}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        searchHistoryModel = [];

        for (var item in response['searchHistory']) {
          searchHistoryModel.add(SearchHistoryModel.fromJson(item));
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



  Future<bool> fnSearchRecentListenTrack() async {

    return true;
  }


  Future<bool> setSearchHistory(String searchText,offset) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/setSearchHistory?loginMemberId=${loginMemberId}&searchText=$searchText&offset=$offset';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {


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
