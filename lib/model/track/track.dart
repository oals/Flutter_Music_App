
import 'package:json_annotation/json_annotation.dart';
import 'package:skrrskrr/model/track/track_list.dart';

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
  String? memberImagePath;

  int? playListId;

  int? trackCategoryId;

  String? categoryNm;

  bool? trackLikeStatus;

  bool? followMember;

  int? commentsCnt;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> trackListCd = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<Track> recommendTrackList = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isPlaying = false;

  Track();

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
  Map<String, dynamic> toJson() => _$TrackToJson(this);

  void updateApiData(Track updatedTrack) {
    trackId = updatedTrack.trackId ?? trackId;
    trackNm = updatedTrack.trackNm ?? trackNm;
    trackTime = updatedTrack.trackTime ?? trackTime;
    trackPrivacy = updatedTrack.trackPrivacy ?? trackPrivacy;
    trackInfo = updatedTrack.trackInfo ?? trackInfo;
    trackImagePath = updatedTrack.trackImagePath ?? trackImagePath;
    trackPlayCnt = updatedTrack.trackPlayCnt ?? trackPlayCnt;
    trackLikeCnt = updatedTrack.trackLikeCnt ?? trackLikeCnt;
    trackUploadDate = updatedTrack.trackUploadDate ?? trackUploadDate;
    memberId = updatedTrack.memberId ?? memberId;
    memberTrackid = updatedTrack.memberTrackid ?? memberTrackid;
    memberNickName = updatedTrack.memberNickName ?? memberNickName;
    memberImagePath = updatedTrack.memberImagePath ?? memberImagePath;
    playListId = updatedTrack.playListId ?? playListId;
    trackCategoryId = updatedTrack.trackCategoryId ?? trackCategoryId;
    categoryNm = updatedTrack.categoryNm ?? categoryNm;
    trackLikeStatus = updatedTrack.trackLikeStatus ?? trackLikeStatus;
    followMember = updatedTrack.followMember ?? followMember;
    commentsCnt = updatedTrack.commentsCnt ?? commentsCnt;
  }

}