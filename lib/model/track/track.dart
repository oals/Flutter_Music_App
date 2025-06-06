import 'package:json_annotation/json_annotation.dart';

part 'track.g.dart';

@JsonSerializable()
class Track {

  int? trackId;

  String? trackNm;

  String? trackTime;

  bool? isTrackPrivacy;

  String? trackInfo;

  String? trackImagePath;

  String? trackPath;

  int? trackPlayCnt;

  int? trackLikeCnt;

  String? trackUploadDate;

  int? memberId;

  String? memberNickName;

  String? memberImagePath;

  int? trackCategoryId;

  bool? isTrackLikeStatus;

  bool? isFollowMember;

  int? commentsCnt;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<String> trackListCd = [];

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isPlaying = false;

  Track();

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
  Map<String, dynamic> toJson() => _$TrackToJson(this);

  void updateApiData(Track updatedTrack) {
    trackId = updatedTrack.trackId ?? trackId;
    trackNm = updatedTrack.trackNm ?? trackNm;
    trackTime = updatedTrack.trackTime ?? trackTime;
    isTrackPrivacy = updatedTrack.isTrackPrivacy ?? isTrackPrivacy;
    trackInfo = updatedTrack.trackInfo ?? trackInfo;
    trackImagePath = updatedTrack.trackImagePath ?? trackImagePath;
    trackPlayCnt = updatedTrack.trackPlayCnt ?? trackPlayCnt;
    trackLikeCnt = updatedTrack.trackLikeCnt ?? trackLikeCnt;
    trackUploadDate = updatedTrack.trackUploadDate ?? trackUploadDate;
    trackPath = updatedTrack.trackPath ?? trackPath;
    memberId = updatedTrack.memberId ?? memberId;
    memberNickName = updatedTrack.memberNickName ?? memberNickName;
    memberImagePath = updatedTrack.memberImagePath ?? memberImagePath;
    trackCategoryId = updatedTrack.trackCategoryId ?? trackCategoryId;
    isTrackLikeStatus = updatedTrack.isTrackLikeStatus ?? isTrackLikeStatus;
    isFollowMember = updatedTrack.isFollowMember ?? isFollowMember;
    commentsCnt = updatedTrack.commentsCnt ?? commentsCnt;
  }

}