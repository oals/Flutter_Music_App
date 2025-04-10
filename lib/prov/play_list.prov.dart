import 'package:flutter/material.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'dart:convert';


import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/utils/helpers.dart';

class PlayListProv extends ChangeNotifier {
  PlaylistList playlistList = PlaylistList();
  PlayListInfoModel playListInfoModel = PlayListInfoModel();

  void notify() {
    notifyListeners();
  }

  void clear() {
    playlistList = PlaylistList();
    playListInfoModel = PlayListInfoModel();
  }

  List<PlayListInfoModel> playListFilter(String playListCd) {
    return playlistList.playList.where((item) => item.playListCd.contains(playListCd)).toList();
  }

  void addPlayListsToModel(List<dynamic> playLists, String playListCd) {
    for (var item in playLists) {
      PlayListInfoModel playListInfoModel = PlayListInfoModel.fromJson(item);
      playListInfoModel.playListCd.add(playListCd);

      int duplicateIndex = playlistList.playList.indexWhere((existingPlayList) => existingPlayList.playListId == playListInfoModel.playListId);

      if (duplicateIndex == -1) {
        playlistList.playList.add(playListInfoModel);
      } else {

        PlayListInfoModel existingPlayList = playlistList.playList.removeAt(duplicateIndex);
        existingPlayList.playListCd.add(playListCd);
        playlistList.playList.add(existingPlayList); // 기존 데이터가 존재 할 때 새 데이터로 교체
      }
    }
  }

  void initPlayListToModel(List<String> playListCdList){

    try{

      for (String playListCd in playListCdList) {
        List<dynamic> playListCopy = List.from(playlistList.playList);

        for (var item in playListCopy) {
          int duplicateIndex = item.playListCd.indexWhere((playListItemCd) => playListItemCd.toString() == playListCd);

          if (duplicateIndex != -1) {
            if (item.playListCd.length == 1) {
              playlistList.playList.remove(item); // 복사본에서 순회 후 삭제
            } else {
              item.playListCd.removeAt(duplicateIndex);
            }
          }
        }

      }
    } catch (e, stacktrace) {
      print('오류 발생: $e');
      print('스택 트레이스: $stacktrace');
    }
  }



  Future<bool> getSearchPlayList(String searchText, int offset, int limit) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getSearchPlayList?loginMemberId=${loginMemberId}&searchText=$searchText&limit=${limit}&offset=$offset';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {
        // 성공적으로 데이터를 가져옴

        if (offset == 0) {
          initPlayListToModel(["SearchPlayList"]);
        }

        addPlayListsToModel(response['playListList'], "SearchPlayList");

        playlistList.searchPlayListTotalCount = response['playListListCnt'];

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

  Future<bool> getMemberPagePlayList(int memberId, int offset, int limit) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getMemberPagePlayList?loginMemberId=${loginMemberId}&memberId=${memberId}&limit=${limit}&offset=$offset';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {

        if (offset == 0) {
          initPlayListToModel(["MemberPagePlayList"]);
        }

        addPlayListsToModel(response['playListList'], "MemberPagePlayList");

        playlistList.memberPagePlayListTotalCount = response['playListListCnt'];

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

  Future<bool> getHomeInitPlayList() async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getHomeInitPlayList?loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {

        initPlayListToModel(["HomeInitPlayList"]);
        addPlayListsToModel(response['popularPlayList'], "HomeInitPlayList");

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

        if (offset == 0) {
          initPlayListToModel(["PlayLists"]);
        }

        addPlayListsToModel(response['playList'], "PlayLists");

        playlistList.myPlayListTotalCount = response['totalCount'];


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

        playListInfoModel = PlayListInfoModel();
        playListInfoModel = PlayListInfoModel.fromJson(response['playList']);

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
