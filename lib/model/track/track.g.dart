// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) => Track()
  ..trackId = (json['trackId'] as num?)?.toInt()
  ..trackNm = json['trackNm'] as String?
  ..trackTime = json['trackTime'] as String?
  ..isTrackPrivacy = json['isTrackPrivacy'] as bool?
  ..trackInfo = json['trackInfo'] as String?
  ..trackImagePath = json['trackImagePath'] as String?
  ..trackPlayCnt = (json['trackPlayCnt'] as num?)?.toInt()
  ..trackLikeCnt = (json['trackLikeCnt'] as num?)?.toInt()
  ..trackUploadDate = json['trackUploadDate'] as String?
  ..memberId = (json['memberId'] as num?)?.toInt()
  ..memberTrackid = (json['memberTrackid'] as num?)?.toInt()
  ..memberNickName = json['memberNickName'] as String?
  ..memberImagePath = json['memberImagePath'] as String?
  ..playListId = (json['playListId'] as num?)?.toInt()
  ..trackCategoryId = (json['trackCategoryId'] as num?)?.toInt()
  ..categoryNm = json['categoryNm'] as String?
  ..isTrackLikeStatus = json['isTrackLikeStatus'] as bool?
  ..isFollowMember = json['isFollowMember'] as bool?
  ..commentsCnt = (json['commentsCnt'] as num?)?.toInt();

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'trackId': instance.trackId,
      'trackNm': instance.trackNm,
      'trackTime': instance.trackTime,
      'isTrackPrivacy': instance.isTrackPrivacy,
      'trackInfo': instance.trackInfo,
      'trackImagePath': instance.trackImagePath,
      'trackPlayCnt': instance.trackPlayCnt,
      'trackLikeCnt': instance.trackLikeCnt,
      'trackUploadDate': instance.trackUploadDate,
      'memberId': instance.memberId,
      'memberTrackid': instance.memberTrackid,
      'memberNickName': instance.memberNickName,
      'memberImagePath': instance.memberImagePath,
      'playListId': instance.playListId,
      'trackCategoryId': instance.trackCategoryId,
      'categoryNm': instance.categoryNm,
      'isTrackLikeStatus': instance.isTrackLikeStatus,
      'isFollowMember': instance.isFollowMember,
      'commentsCnt': instance.commentsCnt,
    };
