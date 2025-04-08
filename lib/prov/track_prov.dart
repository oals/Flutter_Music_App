import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/model/comn/upload.dart';
import 'package:http_parser/http_parser.dart';
import 'package:skrrskrr/prov/more_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';

class TrackProv extends ChangeNotifier {
  Upload model = Upload();

  TrackList trackModel = TrackList();

  Track trackInfoModel = Track();

  TrackList lastListenTrackList = TrackList();
  Track playTrackInfoModel = Track();
  String lastTrackId = "";

  void notify() {
    notifyListeners();
  }

  void addUniqueTracksToList({
    required List<Track> sourceList, // 필터링할 원본 리스트
    required Set<Track> targetSet,  // 중복 체크용 Set
    required List<Track> targetList, // 데이터가 추가될 리스트
    required int trackCd, // 필터링 조건 함수
  }) {
    sourceList.where((item) => item.trackListCd.contains(trackCd)).forEach((item) {
      if (!targetSet.contains(item)) {
        targetList.add(item); // 중복되지 않은 항목만 추가
        targetSet.add(item);  // Set에도 추가
      }
    });
  }


  void addTracksToModel(List<dynamic> trackList, int trackListCd) {
    for (var item in trackList) {
      Track track = Track.fromJson(item);
      track.trackListCd.add(trackListCd);

      int duplicateIndex = trackModel.trackList.indexWhere((existingTrack) => existingTrack.trackId == track.trackId);

      if (duplicateIndex == -1) {
        if(track.trackId.toString() == playTrackInfoModel.trackId.toString()){
          playTrackInfoModel.trackListCd.add(trackListCd);
          trackModel.trackList.add(playTrackInfoModel);
        } else {
          trackModel.trackList.add(track);
        }
      } else {
        trackModel.trackList[duplicateIndex].trackListCd.add(trackListCd);

        Track existingTrack = trackModel.trackList.removeAt(duplicateIndex);
        trackModel.trackList.add(existingTrack);

      }
    }
  }

  void initTrackToModel(List<int> trackCdList){

    try{

      for (int trackCd in trackCdList) {
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




  Future<bool> getHomeInitTrack() async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getHomeInitTrack?loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {
        initTrackToModel([1,2,3,4]);

        addTracksToModel(response['lastListenTrackList'], 1);
        addTracksToModel(response['trendingTrackList'], 2);
        addTracksToModel(response['followMemberTrackList'], 3);
        addTracksToModel(response['likedTrackList'], 4);

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

  Future<bool> getPlayListTrackList(int playListId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getPlayListTrackList?loginMemberId=${loginMemberId}&playListId=${playListId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {

        // trackModel = TrackList(); // 5만 초기화하게
        initTrackToModel([5]);
        addTracksToModel(response['playListTrackList'], 5);


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


  Future<bool> getSearchTrack(String searchText, int offset) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getSearchTrack?loginMemberId=${loginMemberId}&searchText=$searchText&limit=${20}&offset=$offset';

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
          initTrackToModel([6]);
        }

        addTracksToModel(response['searchTrackList'], 6);

        trackModel.searchTrackTotalCount = response['totalCount'];
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

  Future<bool> getMemberPageTrack(int memberId, int offset) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getMemberPageTrack?memberId=${memberId}&loginMemberId=${loginMemberId}&limit=${20}&offset=${offset}';

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
          initTrackToModel([8]);
        }

        addTracksToModel(response['allTrackList'], 8 );

        trackModel.allTrackTotalCount = response['allTrackListCnt'];

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


  Future<bool> getMemberPagePopularTrack(int memberId) async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getMemberPagePopularTrack?memberId=${memberId}&loginMemberId=${loginMemberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == "200") {
        // 성공적으로 데이터를 가져옴
        initTrackToModel([7]);

        addTracksToModel(response['popularTrackList'], 7);

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
    final url = '/api/getLikeTrack?loginMemberId=${loginMemberId}&limit=${20}&offset=${offset}';

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
          initTrackToModel([9]);
        }

        addTracksToModel(response['likeTrackList'], 9 );

        trackModel.likeTrackTotalCount = response['totalCount'];

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


  void fnChngTrackLikeStatus(Track track){

    track.trackLikeStatus = !track.trackLikeStatus!;

    if(track.trackLikeStatus!) {
      track.trackLikeCnt = track.trackLikeCnt! + 1;
    } else {
      track.trackLikeCnt = track.trackLikeCnt! - 1;
    }

    // if (track.trackId == playTrackInfoModel.trackId) {
    //   playTrackInfoModel.trackLikeStatus = track.trackLikeStatus!;
    //   playTrackInfoModel.trackLikeCnt = track.trackLikeCnt;
    //   trackInfoModel.trackLikeStatus = track.trackLikeStatus;
    //   trackInfoModel.trackLikeCnt = track.trackLikeCnt;
    // }
  }


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

    }

    // 이미지 파일 추가
    if (uploadTrackList[0].uploadImage != null) {
      fileList.add(await Helpers.fnSetUploadImageFile(uploadTrackList[0], "uploadImage"));
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
          'trackCategoryId': (categoryCd + 1).toString(),
          'trackPrivacy': isPrivacy.toString(),
        },
      );

      if (response['status'] == "200") {

        trackModel = TrackList();
        await getUploadTrack(0);
        notify();
        print('Upload successful');
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
          initTrackToModel([10]);
        }

        addTracksToModel(response['uploadTrackList'], 10 );

        trackModel.uploadTrackTotalCount = response['totalCount'];


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
