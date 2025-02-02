import 'package:flutter/material.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'dart:convert';

import 'package:skrrskrr/model/playList/play_list_model.dart';
import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/utils/helpers.dart';

class PlayListProv extends ChangeNotifier {

  PlaylistList playlistList = PlaylistList();
  PlayListInfoModel modelPlayInfo = PlayListInfoModel();

  void notify() {
    notifyListeners();
  }


  Future<bool> setPlayListLike(int playListId) async {
    final String memberId = await Helpers.getMemberId();
    final url = 'setPlayListLike'; // POST URL

    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json', // JSON 형식
          },
          body: {
            'memberId': memberId,
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

    final url = 'setPlayListInfo';

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

  Future<bool> getPlayList(int trackId,int listIndex,bool isAlbum) async {

    final String memberId = await Helpers.getMemberId();
    final url = 'getPlayList?memberId=${memberId}&trackId=${trackId}&listIndex=${listIndex}&isAlbum=${isAlbum}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {
        if(listIndex == 0 ){
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

  Future<bool> getPlayListInfo(int playListId) async {

    final String memberId = await Helpers.getMemberId();
    final url = 'getPlayListInfo?playListId=${playListId}&memberId=${memberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {
        modelPlayInfo = PlayListInfoModel();
        modelPlayInfo = PlayListInfoModel.fromJson(response['playList']);
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
    final url = 'setPlayListTrack';

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

    final String memberId = await Helpers.getMemberId();
    final url = 'newPlayList';

    try {
      final response = await Helpers.apiCall(
            url,
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: {
              'memberId': memberId,
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
