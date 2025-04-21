import 'package:flutter/material.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'dart:convert';


import 'package:skrrskrr/model/playList/playlist_list.dart';
import 'package:skrrskrr/utils/helpers.dart';

class PlayListProv extends ChangeNotifier {
  PlaylistList playlists = PlaylistList();
  PlaylistList albums = PlaylistList();
  PlayListInfoModel playListInfoModel = PlayListInfoModel();

  void notify() {
    notifyListeners();
  }

  void clear() {
    playlists = PlaylistList();
    playListInfoModel = PlayListInfoModel();
  }


  Future<bool> getSearchPlayList(String searchText, int offset, int limit) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getSearchPlayList?loginMemberId=${loginMemberId}&isAlbum=${false}&searchText=$searchText&limit=${limit}&offset=$offset';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {
        // 성공적으로 데이터를 가져옴

        if (offset == 0){
          playlists = PlaylistList();
        }

        for(var item in response['playListList']){
          playlists.playList.add(PlayListInfoModel.fromJson(item));
        }

        playlists.searchPlayListTotalCount = response['playListListCnt'];

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
          playlists = PlaylistList();
        }

        for(var item in response['playListList']){
          playlists.playList.add(PlayListInfoModel.fromJson(item));
        }

        playlists.memberPagePlayListTotalCount = response['playListListCnt'];

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


  Future<bool> getMemberPageAlbum(int memberId, int offset, int limit) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getMemberPageAlbums?loginMemberId=${loginMemberId}&memberId=${memberId}&limit=${limit}&offset=$offset';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {

        if (offset == 0) {
          albums = PlaylistList();
        }

        for(var item in response['playListList']){
          albums.playList.add(PlayListInfoModel.fromJson(item));
        }

        albums.memberPageAlbumTotalCount = response['playListListCnt'];

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

  Future<bool> getRecommendPlayList() async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getRecommendPlayList?loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {

        playlists = PlaylistList();

        for(var item in response['recommendPlayList']){
          playlists.playList.add(PlayListInfoModel.fromJson(item));
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


  Future<bool> getRecommendAlbum() async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getRecommendAlbum?loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {

        albums = PlaylistList();

        for(var item in response['recommendAlbum']){
          albums.playList.add(PlayListInfoModel.fromJson(item));
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

  Future<bool> getLikePlayList(int offset,bool isAlbum) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getLikePlayList?loginMemberId=${loginMemberId}&limit=${20}&offset=${offset}&isAlbum=${isAlbum}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response['status'] == '200')) {

        if (offset == 0){
          playlists = PlaylistList();
        }

        for (var item in response['playList']) {
          playlists.playList.add(PlayListInfoModel.fromJson(item));
        }

        playlists.myPlayListTotalCount = response['totalCount'];


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

        if (offset == 0){
          playlists = PlaylistList();
        }

        for (var item in response['playList']) {
          playlists.playList.add(PlayListInfoModel.fromJson(item));
        }

        playlists.myPlayListTotalCount = response['totalCount'];


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

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getPlayListInfo?playListId=${playListId}&loginMemberId=${loginMemberId}';

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
        playlists = PlaylistList();
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
