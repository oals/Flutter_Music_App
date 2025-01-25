
import 'package:json_annotation/json_annotation.dart';

part 'track.g.dart'; // 생성될 파일

@JsonSerializable()
class Track {

  int? trackId;

  String? trackNm;

  String? trackTime;

  bool? trackPrivacy;

  String? trackInfo;

  String? trackImagePath;

  int? trackPlayCnt;

  int? trackLikeCnt;

  String? trackUploadDate;

  int? memberId;

  int? memberTrackid;

  String? memberNickName;

  int? playListId;

  int? trackCategoryId;

  String? categoryNm;

  bool? trackLikeStatus;

  bool? followMember;

  int? commentsCnt;


  Track();

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
  Map<String, dynamic> toJson() => _$TrackToJson(this);

}