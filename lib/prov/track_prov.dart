
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

      if (response['status'] == "200") {
        // 성공적으로 데이터를 가져옴
        if(listIndex == 0){
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
      model.trackTime = '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      print("Duration을 가져오는 데 실패했습니다.");
    }
  }




  Future<void> uploadTrack(
                            bool isAlbum,
                            List<Upload> uploadTrackList,
                            String title,
                            String info,
                            bool isPrivacy,
                            int category) async {


    final String memberId = await Helpers.getMemberId();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse( dotenv.get('API_URL') + 'trackUpload'),
    );

    request.fields['memberId'] = memberId;
    request.fields[ isAlbum ? 'albumNm' :'trackNm'] = title;
    request.fields['trackInfo'] = info;
    request.fields['trackTime'] = model.trackTime ?? "00:00";
    request.fields['trackCategoryId'] = (category + 1).toString();
    request.fields['album'] = isAlbum.toString();
    request.fields['trackPrivacy'] = isPrivacy.toString();


    // 여러 파일을 업로드하는 과정
    for (Upload upload in uploadTrackList) {
      // uploadFile이 null이 아닌 경우에만 처리
      if (upload.uploadFile != null && upload.uploadFile!.files.isNotEmpty) {
        // 파일을 읽어들여 바이트 배열로 변환
        File file = File(upload.uploadFile!.files.first.path.toString());
        List<int> fileBytes = await file.readAsBytes();

        // 바이트 배열을 멀티파트 파일로 추가
        request.files.add(
          http.MultipartFile.fromBytes(
            'uploadFileList', // 서버에서 받을 필드 이름
            fileBytes, // 선택한 파일의 바이트
            filename: upload.uploadFileNm, // 파일 이름
            contentType: MediaType('audio', 'mpeg'), // MIME 타입
          ),
        );
      }


      // 이미지 파일 추가
      if(uploadTrackList[0].uploadImage != null){

        File file = File(uploadTrackList[0].uploadImage!.files.first.path.toString());
        List<int> fileBytes = await file.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'uploadImage', // 서버에서 받을 필드 이름
            fileBytes,
            filename: uploadTrackList[0].uploadImageNm ?? "", // 파일 이름
            contentType: MediaType('image', 'jpeg'), // MIME 타입 (필요에 따라 수정)
          ),
        );
      }
    }

    // 요청 보내기
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      if (jsonResponse['status'] == "200") {
        print('Upload successful');
        trackModel = TrackList();
        await getUploadTrack(0);
        notify();
      } else {
        print('Upload Fail');
      }
    } else {
      print('Upload Fail');
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

      if (response['status'] == "200") {
        if(listIndex == 0) {
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

  Future<bool> getTrackInfo(trackId) async {
    final String memberId = await Helpers.getMemberId();
    final url = 'getTrackInfo?trackId=${trackId}&memberId=${memberId}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        // 성공적으로 데이터를 가져옴
        trackModel = TrackList();
        trackInfoModel = Track();
        trackInfoModel = Track.fromJson(response['trackInfo']);

        for(var data in response['recommendTrack']){
          trackModel.trackList.add(Track.fromJson(data));
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