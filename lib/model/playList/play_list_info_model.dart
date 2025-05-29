import 'package:json_annotation/json_annotation.dart';
import 'package:skrrskrr/model/track/track.dart';

part 'play_list_info_model.g.dart';

@JsonSerializable()
class PlayListInfoModel {

  int? playListId;

  String? playListNm;

  int? playListLikeCnt;

  bool? isPlayListPrivacy;

  String? playListImagePath;

  bool? isInPlayList;

  bool? isPlayListLike;

  String? totalPlayTime;

  int? trackCnt;

  int? memberId;

  String? memberNickName;

  String? memberImagePath;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> playListCd = [];

  PlayListInfoModel();

  factory PlayListInfoModel.fromJson(Map<String, dynamic> json) => _$PlayListInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayListInfoModelToJson(this);

  void updateApiData(PlayListInfoModel updatedPlayList) {
    playListId = updatedPlayList.playListId ?? playListId;
    playListNm = updatedPlayList.playListNm ?? playListNm;
    playListLikeCnt = updatedPlayList.playListLikeCnt ?? playListLikeCnt;
    isPlayListPrivacy = updatedPlayList.isPlayListPrivacy ?? isPlayListPrivacy;
    playListImagePath = updatedPlayList.playListImagePath ?? playListImagePath;
    isInPlayList = updatedPlayList.isInPlayList ?? isInPlayList;
    isPlayListLike = updatedPlayList.isPlayListLike ?? isPlayListLike;
    totalPlayTime = updatedPlayList.totalPlayTime ?? totalPlayTime;
    trackCnt = updatedPlayList.trackCnt ?? trackCnt;
    memberId = updatedPlayList.memberId ?? memberId;
    memberNickName = updatedPlayList.memberNickName ?? memberNickName;
    memberImagePath = updatedPlayList.memberImagePath ?? memberImagePath;
  }

}