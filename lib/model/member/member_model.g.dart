// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel()
  ..memberId = (json['memberId'] as num?)?.toInt()
  ..memberEmail = json['memberEmail'] as String?
  ..memberNickName = json['memberNickName'] as String?
  ..memberInfo = json['memberInfo'] as String?
  ..memberBirth = json['memberBirth'] as String?
  ..memberAddr = json['memberAddr'] as String?
  ..memberDate = json['memberDate'] as String?
  ..memberFollowCnt = (json['memberFollowCnt'] as num?)?.toInt()
  ..playListListCnt = (json['playListListCnt'] as num?)?.toInt()
  ..allTrackListCnt = (json['allTrackListCnt'] as num?)?.toInt()
  ..memberFollowerCnt = (json['memberFollowerCnt'] as num?)?.toInt()
  ..memberImagePath = json['memberImagePath'] as String?
  // ..popularTrackList = (json['popularTrackList'] as List<dynamic>?)
  //     ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
  //     .toList()
  // ..playListList = (json['playListList'] as List<dynamic>)
  //     .map((e) => PlayListModel.fromJson(e as Map<String, dynamic>))
  //     .toList()
  // ..allTrackList = (json['allTrackList'] as List<dynamic>?)
  //     ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
  //     .toList()
  ..isFollowedCd = (json['isFollowedCd'] as num?)?.toInt();

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'memberEmail': instance.memberEmail,
      'memberNickName': instance.memberNickName,
      'memberInfo': instance.memberInfo,
      'memberBirth': instance.memberBirth,
      'memberAddr': instance.memberAddr,
      'memberDate': instance.memberDate,
      'memberFollowCnt': instance.memberFollowCnt,
      'playListListCnt': instance.playListListCnt,
      'allTrackListCnt': instance.allTrackListCnt,
      'memberFollowerCnt': instance.memberFollowerCnt,
      'memberImagePath': instance.memberImagePath,
      // 'popularTrackList': instance.popularTrackList,
      // 'playListList': instance.playListList,
      // 'allTrackList': instance.allTrackList,
      'isFollowedCd': instance.isFollowedCd,
    };
