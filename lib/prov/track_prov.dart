
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/model/track/track_list.dart';
import 'package:skrrskrr/model/comn/upload.dart';
import 'package:http_parser/http_parser.dart';
import 'package:skrrskrr/utils/helpers.dart';

class TrackProv extends ChangeNotifier{

  Upload model = Upload();
  TrackList trackModel = TrackList();
  Track trackInfoModel = Track();


  void notify() {
    notifyListeners();
  }

  Future<bool> setTrackInfo(String? trackInfo) async {

    final url = "setTrackInfo";
    
    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body: {
            'trackId' : trackInfoModel.trackId,
            'trackInfo' : trackInfo,
          }
      );
      

      if (response != null) {

        print('setTrackInfo');


      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('SearchTrack Error: $error');
      return false;
    }
    return true;
  }


  Future<bool> getLikeTrack(listIndex) async {
    
    final String memberId = await Helpers.getMemberId();
    final url = 'getLikeTrack?memberId=${memberId}&listIndex=${listIndex}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        // 성공적으로 데이터를 가져옴

        if(listIndex == 0){
          trackModel = TrackList();
        }

        for (var item in response['likeTrackList']) {
          trackModel.trackList.add(Track.fromJson(item));
        }

        trackModel.totalCount = response['totalCount'];

      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('SearchTrack Error: $error');
      return false;
    }
    return true;
  }

  Future<bool> setTrackLike(trackId) async {

    final String memberId = await Helpers.getMemberId();
    final url = 'setTrackLike?memberId=${memberId}&trackId=${trackId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        // 성공적으로 데이터를 가져옴

        print(response);


      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('SearchTrack Error: $error');
      return false;
    }
    return true;
  }

  void getUploadTrackTime() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    String? filePath = model.uploadFile?.files.single.path!;

    // 파일을 로드하고 길이를 가져옴
    await audioPlayer.setSourceUrl(filePath!); // URL을 사용하여 재생
    Duration? duration = await audioPlayer.getDuration();


    // 길이를 출력
    if (duration != null) {
      model.trackTime = '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      print("Duration을 가져오는 데 실패했습니다.");
    }
  }


  Future<void> uploadTrack() async {


    final String memberId = await Helpers.getMemberId();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse( dotenv.get('API_URL') + 'trackUpload'),
    );


    request.fields['memberId'] = memberId;
    request.fields['trackNm'] = model.trackNm ?? "제목 없음";
    request.fields['trackInfo'] = model.trackInfo ?? "내용 없음";
    request.fields['trackTime'] = model.trackTime ?? "00:00";
    request.fields['trackCategoryId'] = (model.trackCategoryId + 1).toString();
    request.fields['albumId'] = model.albumId.toString();
    request.fields['trackPrivacy'] = model.isTrackPrivacy.toString();


    File file = File(model.uploadFile!.files.first.path.toString());
    List<int> fileBytes = await file.readAsBytes();

    // 바이트 배열을 멀티파트 파일로 추가
    request.files.add(
      http.MultipartFile.fromBytes(
        'uploadFile', // 서버에서 받을 필드 이름
        fileBytes, // 선택한 파일의 바이트
        filename: model.uploadFileNm, // 파일 이름
        contentType: MediaType('audio', 'mpeg'),
      ),
    );

    // 이미지 파일 추가
    if(model.uploadImage != null){

      File file = File(model.uploadImage!.files.first.path.toString());
      List<int> fileBytes = await file.readAsBytes();


      request.files.add(
        http.MultipartFile.fromBytes(
          'uploadImage', // 서버에서 받을 필드 이름
          fileBytes,
          filename: model.uploadImageNm ?? "", // 파일 이름
          contentType: MediaType('image', 'jpeg'), // MIME 타입 (필요에 따라 수정)
        ),
      );
    }



    // 요청 보내기
    var response = await request.send();

    if (response != null) {

      var responseBody = await http.Response.fromStream(response);
      bool isUpload = json.decode(responseBody.body);

      if (isUpload){
        print('Upload successful');

        trackModel = TrackList();
        await getUploadTrack(0);
        notify();

      } else {
        print('Upload failed: ${response.statusCode}');
      }

    } else {
      print('Upload failed: ${response.statusCode}');
    }
  }


  Future<bool> getUploadTrack(int listIndex) async {

    final String memberId = await Helpers.getMemberId();
    final url = 'getUploadTrack?memberId=${memberId}&listIndex=${listIndex}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        // 성공적으로 데이터를 가져옴

        print(response);

        if(listIndex == 0) {
          trackModel = TrackList();
        }

        for (var item in response['uploadTrackList']) {
          trackModel.trackList.add(Track.fromJson(item));
        }

        trackModel.totalCount = response['totalCount'];

        ///isTrackPrivacy 가 아니라 trackPrivacy가 반환되는데 뭐지

        print(trackModel);

      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('SearchTrack Error: $error');
      return false;
    }


    return true;
  }

  Future<bool> getTrackInfo(trackId) async {
    print("getTrackInfo");
    final String memberId = await Helpers.getMemberId();
    final url = 'getTrackInfo?trackId=${trackId}&memberId=${memberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        // 성공적으로 데이터를 가져옴

        print(response);


        trackModel = TrackList();
        trackInfoModel = Track();

        trackInfoModel = Track.fromJson(response['trackInfo']);

        for(var data in response['recommendTrack']){
          trackModel.trackList.add(Track.fromJson(data));
        }


      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('SearchTrack Error: $error');
      return false;
    }
    return true;
  }

}