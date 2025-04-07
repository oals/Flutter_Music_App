import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/utils/helpers.dart';

class MoreProv extends ChangeNotifier{

  SearchModel moreModel = SearchModel();
  bool isApiCall = false;
  bool isLoading = false;
  int offset = 0;

  void notify() {
    notifyListeners();
  }

  void clear(){
    moreModel = SearchModel();
    isApiCall = false;
    offset = 0;
  }

  Future<void> loadMoreData(int moreId, String? searchText, String? memberId) async {
    if (!isApiCall) {
      isLoading = true;
      setApiCallStatus(true);
      offset += 20;
      await Future.delayed(Duration(seconds: 3));  // API 호출 후 지연 처리
      await searchMore(moreId, searchText, memberId, offset);
      setApiCallStatus(false);
      isLoading = false;
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


  Future<bool> searchMore(int moreId, String? searchText, String? memberId ,int offset) async {

    final String loginMemberId = await Helpers.getMemberId();

    final url= '/api/getSearchMore?'
        'loginMemberId=${loginMemberId}&'
        'memberId=${memberId}&'
        'moreId=${moreId}&searchText=${searchText}&'
        'limit=${20}&'
        'offset=${offset}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {
        if (offset == 0) {
          moreModel.trackList = [];
          moreModel.memberList = [];
          moreModel.playListList = [];
        }

        if(moreId == 1) {
          for (var item in response['memberList']) {
            moreModel.memberList.add(FollowInfoModel.fromJson(item));
          }
          moreModel.totalCount = response['totalCount'];
        } else if (moreId == 2 || moreId == 4) {
          for (var item in response['playListList']) {
            moreModel.playListList.add(PlayListInfoModel.fromJson(item));
          }
          moreModel.totalCount = response['totalCount'];
        } else if (moreId == 3 || moreId == 5) {
          for (var item in response['trackList']) {
            moreModel.trackList.add(Track.fromJson(item));
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


}