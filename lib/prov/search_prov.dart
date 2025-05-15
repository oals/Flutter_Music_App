import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/utils/comn_utils.dart';
import 'package:http/http.dart' as http;

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

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getSearchTextHistory?loginMemberId=${loginMemberId}&limit=${30}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        searchHistoryModel = [];

        for (var item in ComnUtils.extractValue(response.body, "searchHistoryList")) {
          searchHistoryModel.add(SearchHistoryModel.fromJson(item));
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

  Future<bool> fnSearchRecentListenTrack() async {

    return true;
  }

  Future<bool> setSearchHistory(String searchText,offset) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/setSearchHistory?loginMemberId=${loginMemberId}&searchText=$searchText&offset=$offset';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
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
