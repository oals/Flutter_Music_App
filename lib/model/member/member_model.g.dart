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
  ..memberFollowerCnt = (json['memberFollowerCnt'] as num?)?.toInt()
  ..memberImagePath = json['memberImagePath'] as String?
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
      'memberFollowerCnt': instance.memberFollowerCnt,
      'memberImagePath': instance.memberImagePath,
      'isFollowedCd': instance.isFollowedCd,
    };
