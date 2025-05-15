import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/model/upload/upload.dart';
import 'package:skrrskrr/prov/player_prov.dart';

import 'package:skrrskrr/utils/comn_utils.dart';

class TrackProv extends ChangeNotifier {
  Upload model = Upload();
  TrackList trackModel = TrackList();
  Track trackInfoModel = Track();

  List<Track> lastListenTrackList = [];
  List<Track> recommendTrackList = [];
  List<Track> audioPlayerTrackList = [];
  String lastTrackId = '';

  void notify() {
    notifyListeners();
  }

  List<Track> trackListFilter(String trackCd) {
    return trackModel.trackList.where((item) => item.trackListCd.contains(trackCd)).toList();
  }

  void addUniqueTracksToList({
    required List<Track> sourceList,
    required Set<Track> targetSet,
    required List<Track> targetList,
    required String trackCd,
  }) {
    sourceList.where((item) => item.trackListCd.contains(trackCd)).forEach((item) {
      if (!targetSet.contains(item)) {
        targetList.add(item);
        targetSet.add(item);
      }
    });
  }

  void addAudioPlayerTracksToModel(List<dynamic> trackList, String trackListCd) {

    for (var item in trackList) {
      Track track = Track.fromJson(item);
      track.trackListCd.add(trackListCd);

      int duplicateIndex = trackModel.trackList.indexWhere((existingTrack) => existingTrack.trackId == track.trackId);

      if (duplicateIndex == -1) {
        audioPlayerTrackList.add(track);
        trackModel.trackList.add(track);
      } else {
        audioPlayerTrackList.add(trackModel.trackList[duplicateIndex]);
      }
    }
  }

  void addTracksToModel(List<dynamic> trackList, String trackListCd) {

    for (var item in trackList) {
      Track track = Track.fromJson(item);
      track.trackListCd.add(trackListCd);

      int duplicateIndex = trackModel.trackList.indexWhere((existingTrack) => existingTrack.trackId == track.trackId);

      if (duplicateIndex == -1) {
        trackModel.trackList.add(track);
      } else {
        Track existingTrack = trackModel.trackList.removeAt(duplicateIndex);
        existingTrack.trackListCd.add(trackListCd);
        trackModel.trackList.add(existingTrack);
      }
    }
  }

  void initTrackToModel(List<String> trackCdList){
    try {
      for (String trackCd in trackCdList) {
        List<dynamic> trackListCopy = List.from(trackModel.trackList);

        for (var item in trackListCopy) {
          int duplicateIndex = item.trackListCd.indexWhere((trackListItemCd) => trackListItemCd == trackCd);

          if (duplicateIndex != -1) {
            if (item.trackListCd.length == 1) {
              trackModel.trackList.remove(item); // 복사본에서 순회 후 삭제
            } else {
              item.trackListCd.removeAt(duplicateIndex);
            }
          }
        }
      }
    } catch (e, stacktrace) {
      print('오류 발생: $e');
      print('스택 트레이스: $stacktrace');
    }
  }

  void updateLastListenTrackList(Track trackItem) {
    lastListenTrackList[0].isPlaying = false;
    lastListenTrackList.removeWhere((track) => track.trackId == trackItem.trackId);
    lastListenTrackList.insert(0, trackItem);
    lastListenTrackList[0].isPlaying = true;
  }

  void initCurrentTrackPlaying(int currentPage) {
      if (audioPlayerTrackList.length > currentPage) {
        audioPlayerTrackList[currentPage].isPlaying = false;
      }
  }

  Future<bool> setTrackPlayCnt(int trackId) async {

    final url = '/api/setTrackPlayCnt';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'trackId' : trackId
        }
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

  Future<bool> getPlayListTrackList(int playListId, int offset, int limit) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getPlayListTrackList?loginMemberId=${loginMemberId}&playListId=${playListId}&limit=${limit}&offset=${offset}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        if (offset == 0){
          initTrackToModel(["PlayListTrackList"]);
        }

        addTracksToModel(ComnUtils.extractValue(response.body,"trackList"), "PlayListTrackList");

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

  Future<bool> getSearchTrack(String searchText, int offset, int limit) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getSearchTrack?loginMemberId=${loginMemberId}&searchText=$searchText&limit=${limit}&offset=$offset';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        if (offset == 0) {
          initTrackToModel(["SearchTrackList"]);
        }

        addTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "SearchTrackList");

        trackModel.searchTrackTotalCount = ComnUtils.extractValue(response.body, "totalCount");

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

  Future<bool> getMemberPageTrack(int memberId, int offset, int limit) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getMemberPageTrack?memberId=${memberId}&loginMemberId=${loginMemberId}&limit=${limit}&offset=${offset}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        if (offset == 0) {
          initTrackToModel(["MemberPageTrackList"]);
        }

        addTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "MemberPageTrackList");

        trackModel.allTrackTotalCount = ComnUtils.extractValue(response.body, "totalCount");

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


  Future<bool> getMemberPagePopularTrack(int memberId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getMemberPagePopularTrack?memberId=${memberId}&loginMemberId=${loginMemberId}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        initTrackToModel(["MemberPagePopularTrackList"]);

        addTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "MemberPagePopularTrackList");

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


  Future<bool> setTrackInfo(String? trackInfo) async {

    final url = "/api/setTrackInfo";

    try {
      http.Response response = await ComnUtils.apiCall(
            url,
            method: "PUT",
            headers: {
              'Content-Type': 'application/json',
            },
            body: {
              'trackId': trackInfoModel.trackId,
              'trackInfo': trackInfo,
            }
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

  Future<bool> setLockTrack(int? trackId, bool isTrackPrivacy) async {

    final url = "/api/setLockTrack";

    try {
      http.Response response = await ComnUtils.apiCall(
            url,
            method: "PUT",
            headers: {
              'Content-Type': 'application/json',
            },
            body: {
              'trackId': trackId,
              'isTrackPrivacy': isTrackPrivacy,
            }
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

  Future<bool> getLikeTrack(int offset, int limit) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getLikeTrack?loginMemberId=${loginMemberId}&limit=${limit}&offset=${offset}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        if (offset == 0) {
          initTrackToModel(["MyLikeTrackList"]);
        }

        addTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "MyLikeTrackList" );

        trackModel.likeTrackTotalCount = ComnUtils.extractValue(response.body, "totalCount");

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

  Future<bool> getLastListenTrackId() async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getLastListenTrackId?loginMemberId=${loginMemberId}';

    try {
      http.Response response = await ComnUtils.apiCall(
          url,
          method: 'GET'
      );

      if (response.statusCode == 200) {

        lastTrackId = ComnUtils.extractValue(response.body, "trackId").toString();

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

  void fnUpdateTrackLikeStatus(Track track){

    track.isTrackLikeStatus = !track.isTrackLikeStatus!;

    if (track.isTrackLikeStatus!) {
      track.trackLikeCnt = track.trackLikeCnt! + 1;
    } else {
      track.trackLikeCnt = track.trackLikeCnt! - 1;
    }

    notify();
  }

  Future<bool> setLastListenTrackId(int trackId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/setLastListenTrackId';

    try {
      http.Response response = await ComnUtils.apiCall(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          method: 'POST',
          body: {
            'loginMemberId' : loginMemberId,
            'trackId' : trackId,
        }
      );

      if (response.statusCode == 200) {

        lastTrackId = trackId.toString();

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

  Future<bool> setAudioPlayerTrackIdList(List<int> audioPlayerTrackIdList) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/setAudioPlayerTrackIdList';

    try {
      http.Response response = await ComnUtils.apiCall(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          method: 'POST',
          body: {
            'loginMemberId' : loginMemberId,
            'trackIdList' : audioPlayerTrackIdList,
          }
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

  Future<bool> setTrackLike(trackId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/setTrackLike';

    try {
      http.Response response = await ComnUtils.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body :{
            'loginMemberId' : loginMemberId,
            'trackId' : trackId
          }
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


  Future<List<http.MultipartFile?>> fnSetUploadFileList(List<Upload> uploadTrackList) async {

    List<http.MultipartFile?> fileList = [];

    // 여러 파일을 업로드하는 과정
    for (Upload upload in uploadTrackList) {

      // uploadFile이 null이 아닌 경우에만 처리
      if (upload.uploadFile != null && upload.uploadFile!.files.isNotEmpty) {
        fileList.add(await ComnUtils.fnSetUploadAudioFile(upload, "uploadFileList"));
      }

    }

    // 이미지 파일 추가
    if (uploadTrackList[0].uploadImage != null) {
      fileList.add(await ComnUtils.fnSetUploadImageFile(uploadTrackList[0], "uploadImage"));
    }

    return fileList;
  }


  Future<void> uploadAlbum(List<Upload> uploadTrackList,
      String title, String info, bool isPrivacy, int categoryId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/albumUpload';

    try {
      List<http.MultipartFile?> fileList = await fnSetUploadFileList(uploadTrackList);

      http.Response response = await ComnUtils.apiCall(
        url,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        fileList: fileList,
        body: {
          'loginMemberId': loginMemberId,
          'albumNm': title,
          'trackInfo': info,
          'trackCategoryId': categoryId.toString(),
          'isTrackPrivacy': isPrivacy.toString(),
        },
      );

      if (response.statusCode == 200) {

        trackModel = TrackList();

        await getUploadTrack(0,20);

        notify();

        print('$url - Successful');
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return null;
    }
  }

  Future<void> uploadTrack(List<Upload> uploadTrackList,
      String title, String info, bool isPrivacy, int categoryId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/trackUpload';

    try {
      List<http.MultipartFile?> fileList = [];

      // 파일을 업로드
      Upload upload = uploadTrackList[0];

      // 파일을 읽어들여 바이트 배열로 변환
      if (upload.uploadFile != null && upload.uploadFile!.files.isNotEmpty) {
          fileList.add(await ComnUtils.fnSetUploadAudioFile(upload, "uploadFile"));
      }

      // 이미지 파일 추가
      if (uploadTrackList[0].uploadImage != null) {
        fileList.add(await ComnUtils.fnSetUploadImageFile(upload, "uploadImage"));
      }

      http.Response response = await ComnUtils.apiCall(
        url,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        fileList: fileList,
        body: {
          'loginMemberId': loginMemberId,
          'trackNm': title,
          'trackInfo': info,
          'trackTime': model.trackTime ?? "00:00",
          'trackCategoryId': categoryId.toString(),
          'isTrackPrivacy': isPrivacy.toString(),
        },
      );

      if (response.statusCode == 200) {

        trackModel = TrackList();

        await getUploadTrack(0,20);

        print('$url - Successful');
        notify();
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print('$url - Fail');
      return null;
    }
  }

  Future<bool> getUploadTrack(int offset, int limit) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getUploadTrack?loginMemberId=${loginMemberId}&limit=${limit}&offset=${offset}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        if (offset == 0) {
          initTrackToModel(["UploadTrackList"]);
        }

        addTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "UploadTrackList" );

        trackModel.uploadTrackTotalCount = ComnUtils.extractValue(response.body, "totalCount");

        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> getAudioPlayerTrackList() async {

    await getLastListenTrackId();

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getAudioPlayerTrackList?loginMemberId=$loginMemberId';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        audioPlayerTrackList = [];

        addAudioPlayerTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "AudioPlayerTrackList");

        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> getTrackInfo(trackId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getTrackInfo?trackId=${trackId}&loginMemberId=${loginMemberId}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        trackInfoModel = Track();

        trackInfoModel = Track.fromJson(ComnUtils.extractValue(response.body, "track"));

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

  Future<bool> getLastListenTrack() async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getLastListenTrackList?loginMemberId=${loginMemberId}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        initTrackToModel(["LastListenTrackList",]);

        addTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "LastListenTrackList");

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

  Future<bool> getRecommendTrackList() async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getRecommendTrack?loginMemberId=${loginMemberId}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        initTrackToModel(["RecommendTrackList",]);

        addTracksToModel(ComnUtils.extractValue(response.body, "trackList"), "RecommendTrackList");

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