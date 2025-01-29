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
    print('setPlayListLike 호출1');
    print(playListId);


    final String memberId = await Helpers.getMemberId();
    final url = 'setPlayListLike'; // POST URL

    try {
      // POST 요청 보내기
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

      if ((response != null)) {
        // 성공적으로 데이터를 가져옴
        print('Successfully set playlist like');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to set playlist like');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }
  }

  Future<bool> setPlayListInfo(int playListId, String playListNewNm) async {
    print('setPlayListInfo 호출');

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

      if ((response != null)) {
        // 성공적으로 데이터를 가져옴

        print('플리에 트랙 추가');
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }

  Future<bool> getPlayList(int trackId,int listIndex,bool isAlbum) async {
    print('getPlaylist 호출1');
    print(trackId);

    final String memberId = await Helpers.getMemberId();
    final url = 'getPlayList?memberId=${memberId}&trackId=${trackId}&listIndex=${listIndex}&isAlbum=${isAlbum}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response != null)) {
        // 성공적으로 데이터를 가져옴

        if(listIndex == 0 ){
          playlistList = PlaylistList();
        }

        for (var item in response['playList']) {
          playlistList.playList.add(PlayListModel.fromJson(item));
        }

        playlistList.totalCount = response['totalCount'];

        print(playlistList.totalCount);
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }

  Future<bool> getPlayListInfo(int playListId) async {
    print('getPlayListInfo 호출1');
    print(playListId);


    final String memberId = await Helpers.getMemberId();
    final url = 'getPlayListInfo?playListId=${playListId}&memberId=${memberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response != null)) {
        // 성공적으로 데이터를 가져옴

        print(response);
        modelPlayInfo = PlayListInfoModel();
        modelPlayInfo = PlayListInfoModel.fromJson(response);

        // print(modelPlayInfo);

      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }


  Future<bool> setPlayListTrack(int playListId, int trackId) async {
    print('setPlayListTrack 호출');

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

      if ((response != null)) {
        // 성공적으로 데이터를 가져옴
        print('플리에 트랙 추가');

      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }

  Future<bool> setNewPlaylist(String playListNm, bool isPlayListPrivacy,bool isAlbum) async {

    final String memberId = await Helpers.getMemberId();
    final url = 'newPlayList';

    print('setNewPlaylist 호출');

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

      if ((response != null)) {
        playlistList = PlaylistList();
        await getPlayList(0, 0,false);
        notify();
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }
}
