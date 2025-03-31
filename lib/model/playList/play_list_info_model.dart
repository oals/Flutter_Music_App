
import 'package:json_annotation/json_annotation.dart';
import 'package:skrrskrr/model/track/track.dart';

part 'play_list_info_model.g.dart'; // 생성될 파일

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

  List<Track>? playListTrackList;

  int? memberId;

  String? memberNickName;


  PlayListInfoModel();

  factory PlayListInfoModel.fromJson(Map<String, dynamic> json) => _$PlayListInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayListInfoModelToJson(this);


}