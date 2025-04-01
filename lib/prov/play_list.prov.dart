import 'package:flutter/material.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'dart:convert';

import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/utils/helpers.dart';

class PlayListProv extends ChangeNotifier {

  PlaylistList playlistList = PlaylistList();
  PlayListInfoModel modelPlayInfo = PlayListInfoModel();
  bool isApiCall = false;
  int offset = 0;


  void notify() {
    notifyListeners();
  }

  void clear() {
    playlistList = PlaylistList();
    modelPlayInfo = PlayListInfoModel();
    isApiCall = false;
    offset = 0;
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

  Future<void> loadMoreData() async {
    if (!isApiCall) {
      setApiCallStatus(true);
      offset = offset + 20;
      await Future.delayed(Duration(seconds: 3));  // API 호출 후 지연 처리

      await getPlayList(0, offset, false);

      setApiCallStatus(false);
    }
  }


  Future<bool> setPlayListLike(int playListId) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/setPlayListLike'; // POST URL

    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json', // JSON 형식
          },
          body: {
            'loginMemberId': loginMemberId,
            'playListId': playListId,
          }
      );

      if ((response['status'] == '200')) {
        // 성공적으로 데이터를 가져옴
        print('$url - Successful');
        return true;
      } else {
        throw Exception('Failed to set playlist like');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> setPlayListInfo(int playListId, String playListNewNm) async {

    final url= '/api/setPlayListInfo';

    try {
      final response = await Helpers.apiCall(
          url,
          method : "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body:{
            'playListId': playListId,
            'playListNm': playListNewNm,
          }
          );

      if ((response['status'] == '200')) {
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

  Future<bool> getPlayList(int trackId,int offset,bool isAlbum) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getPlayList?loginMemberId=${loginMemberId}&trackId=${trackId}&limit=${20}&offset=${offset}&isAlbum=${isAlbum}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {
        if(offset == 0 ){
          playlistList = PlaylistList();
        }
        for (var item in response['playList']) {
          playlistList.playList.add(PlayListModel.fromJson(item));
        }
        playlistList.totalCount = response['totalCount'];
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

  Future<bool> getPlayListInfo(int playListId,int offset) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getPlayListInfo?playListId=${playListId}&loginMemberId=${loginMemberId}&limit=${20}&offset=${offset}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {

        playlistList.playListInfoModel = PlayListInfoModel();

        playlistList.playListInfoModel = PlayListInfoModel.fromJson(response['playList']);

        playlistList.totalCount = playlistList.playListInfoModel!.trackCnt;


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


  Future<bool> setPlayListTrack(int playListId, int trackId) async {
    final url= '/api/setPlayListTrack';

    try {
      final response = await Helpers.apiCall(
            url,
            method : "POST",
            headers: {
              'Content-Type': 'application/json',
            },
            body: {
              'playListId': playListId,
              'trackId': trackId,
            }
          );

      if ((response['status'] == '200')) {
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

  Future<bool> setNewPlaylist(String playListNm, bool isPlayListPrivacy,bool isAlbum) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/newPlayList';

    try {
      final response = await Helpers.apiCall(
            url,
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: {
              'loginMemberId': loginMemberId,
              'playListNm': playListNm,
              'isPlayListPrivacy': isPlayListPrivacy,
              'isAlbum' : isAlbum,
            }
          );

      if ((response['status'] == '200')) {
        playlistList = PlaylistList();
        await getPlayList(0, 0,false);
        notify();
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
