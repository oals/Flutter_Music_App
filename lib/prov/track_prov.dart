import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/model/comn/upload.dart';
import 'package:http_parser/http_parser.dart';
import 'package:skrrskrr/utils/helpers.dart';

class TrackProv extends ChangeNotifier {
  Upload model = Upload();
  TrackList trackModel = TrackList();
  TrackList lastListenTrackList = TrackList();
  Track trackInfoModel = Track();
  Track playTrackInfoModel = Track();
  bool isApiCall = false;
  int offset = 0;

  void notify() {
    notifyListeners();
  }

  void clear() {
    model = Upload();
    trackModel = TrackList();
    trackInfoModel = Track();
    isApiCall = false;
    offset = 0;
  }


  Future<void> loadMoreData(String apiName) async {
    if (!isApiCall) {
      setApiCallStatus(true);
      offset += 20;
      await Future.delayed(Duration(seconds: 3));  // API 호출 후 지연 처리
      if (apiName == 'UploadTrack') {
        await getUploadTrack(offset);
      } else if (apiName == 'LikeTrack'){
        await getLikeTrack(offset);
      }
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

  Future<bool> setTrackInfo(String? trackInfo) async {
    final url = "/api/setTrackInfo";

    try {
      final response = await Helpers.apiCall(
          url,
          method: "PUT",
          headers: {
            'Content-Type': 'application/json',
          }, body: {
            'trackId': trackInfoModel.trackId,
            'trackInfo': trackInfo,
          });

      if (response['status'] == "200") {
        print('$url - Successful');
        return true;
      } else {
        print('$url - Fail');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> setLockTrack(int? trackId, bool isTrackPrivacy) async {
    final url = "/api/setLockTrack";

    try {
      final response = await Helpers.apiCall(
          url,
          method: "PUT",
          headers: {
            'Content-Type': 'application/json',
          }, body: {
            'trackId': trackId,
            'trackPrivacy': isTrackPrivacy,
          });

      if (response['status'] == "200") {
        print('$url - Successful');
        return true;
      } else {
        print('$url - Fail');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> getLikeTrack(offset) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getLikeTrack?loginMemberId=${loginMemberId}&offset=${offset}';

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
          trackModel = TrackList();
        }
        for (var item in response['likeTrackList']) {
          trackModel.trackList.add(Track.fromJson(item));
        }
        trackModel.totalCount = response['totalCount'];
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


  Future<String> getLastListenTrack() async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getLastListenTrackId?loginMemberId=${loginMemberId}';
    try {

      final response = await Helpers.apiCall(
          url,
          method: 'GET'
      );


      if (response['status'] == '200') {
        print('$url - Successful');
        return response['lastListenTrackId'];
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return '-1';
    }
  }


  // Future<bool> getLastListenTrackList() async {
  //
  //   final String loginMemberId = await Helpers.getMemberId();
  //   final url = '/api/getLastListenTrackList?loginMemberId=${loginMemberId}&limit=${15}';
  //   try {
  //
  //     final response = await Helpers.apiCall(
  //         url,
  //         method: 'GET'
  //     );
  //
  //     if (response['status'] == '200') {
  //
  //       lastListenTrackList = TrackList();
  //       for (var item in response['lastListenTrackList']) {
  //         print(item);
  //         lastListenTrackList.trackList.add(Track.fromJson(item));
  //       }
  //
  //
  //       print('$url - Successful');
  //       return true;
  //     } else {
  //       // 오류 처리
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     // 오류 처리
  //     print('$url - Fail');
  //     return false;
  //   }
  // }

  Future<bool> setLastListenTrackId(int trackId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setLastListenTrackId';
    try {
      final response = await Helpers.apiCall(
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

      print(response);
      if (response['status'] == '200') {
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


  Future<bool> setTrackLike(trackId) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setTrackLike';

    try {
      final response = await Helpers.apiCall(
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

      if (response['status'] == "200") {
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

  void getUploadTrackTime() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    String? filePath = model.uploadFile?.files.single.path!;

    // 파일을 로드하고 길이를 가져옴
    await audioPlayer.setSourceUrl(filePath!); // URL을 사용하여 재생
    Duration? duration = await audioPlayer.getDuration();

    // 길이를 출력
    if (duration != null) {
      model.trackTime =
          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      print("Duration을 가져오는 데 실패했습니다.");
    }
  }


  Future<List<http.MultipartFile?>> fnSetUploadFileList(List<Upload> uploadTrackList) async {

    List<http.MultipartFile?> fileList = [];

    // 여러 파일을 업로드하는 과정
    for (Upload upload in uploadTrackList) {

      // uploadFile이 null이 아닌 경우에만 처리
      if (upload.uploadFile != null && upload.uploadFile!.files.isNotEmpty) {
        fileList.add(await Helpers.fnSetUploadAudioFile(upload, "uploadFileList"));
      }

      // 이미지 파일 추가
      if (uploadTrackList[0].uploadImage != null) {
        fileList.add(await Helpers.fnSetUploadImageFile(upload, "uploadImage"));
      }
    }

    return fileList;
  }


  Future<void> uploadAlbum(List<Upload> uploadTrackList,
      String title, String info, bool isPrivacy, int categoryCd) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/albumUpload';
    try {

      List<http.MultipartFile?> fileList = await fnSetUploadFileList(uploadTrackList);

      final response = await Helpers.apiCall(
        url,
        method: 'POST',
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        fileList: fileList,
        body: {
          'loginMemberId': loginMemberId,
          'albumNm': title,
          'trackInfo': info,
          'trackTime': model.trackTime ?? "00:00",
          'trackCategoryId': (categoryCd + 1).toString(),
          'trackPrivacy': isPrivacy.toString(),
        },
      );

      if (response['status'] == "200") {
        print('Upload successful');
        trackModel = TrackList();
        await getUploadTrack(0);
        notify();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return null;
    }
  }

  Future<void> uploadTrack(List<Upload> uploadTrackList,
      String title, String info, bool isPrivacy, int categoryCd) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/trackUpload';
    try {

      List<http.MultipartFile?> fileList = [];

      // 파일을 업로드
      Upload upload = uploadTrackList[0];

      // 파일을 읽어들여 바이트 배열로 변환
      if (upload.uploadFile != null && upload.uploadFile!.files.isNotEmpty) {
          fileList.add(await Helpers.fnSetUploadAudioFile(upload, "uploadFile"));
      }

      // 이미지 파일 추가
      if (uploadTrackList[0].uploadImage != null) {
        fileList.add(await Helpers.fnSetUploadImageFile(upload, "uploadImage"));
      }

      final response = await Helpers.apiCall(
        url,
        method: 'POST',
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        fileList: fileList,
        body: {
          'loginMemberId': loginMemberId,
          'trackNm': title,
          'trackInfo': info,
          'trackTime': model.trackTime ?? "00:00",
          'trackCategoryId': (categoryCd + 1).toString(),
          'trackPrivacy': isPrivacy.toString(),
        },
      );

      if (response['status'] == "200") {
        print('Upload successful');
        trackModel = TrackList();
        await getUploadTrack(0);
        notify();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return null;
    }
  }

  Future<bool> getUploadTrack(int offset) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getUploadTrack?loginMemberId=${loginMemberId}&limit=${20}&offset=${offset}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {
        if (offset == 0) {
          trackModel = TrackList();
        }
        for (var item in response['uploadTrackList']) {
          trackModel.trackList.add(Track.fromJson(item));
        }
        trackModel.totalCount = response['totalCount'];
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


  Future<bool> getPlayTrackInfo(trackId) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getTrackInfo?trackId=${trackId}&loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        // 성공적으로 데이터를 가져옴
        playTrackInfoModel = Track();
        playTrackInfoModel = Track.fromJson(response['trackInfo']);

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



  Future<bool> getTrackInfo(trackId) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getTrackInfo?trackId=${trackId}&loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        // 성공적으로 데이터를 가져옴
        trackInfoModel = Track();
        trackInfoModel = Track.fromJson(response['trackInfo']);

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


  Future<bool> getRecommendTrackList(trackId, int trackCategoryId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getRecommendTrack?loginMemberId=${loginMemberId}&trackId=${trackId}&trackCategoryId=${trackCategoryId}&limit=${5}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        // 성공적으로 데이터를 가져옴
        trackInfoModel.recommendTrackList = [];

        for (var data in response['recommendTrackList']) {
          trackInfoModel.recommendTrackList.add(Track.fromJson(data));
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
}
