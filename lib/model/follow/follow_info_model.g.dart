// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowInfoModel _$FollowInfoModelFromJson(Map<String, dynamic> json) =>
    FollowInfoModel()
      ..followMemberId = (json['followMemberId'] as num?)?.toInt()
      ..followNickName = json['followNickName'] as String?
      ..followImagePath = json['followImagePath'] as String?
      ..mutualFollow = json['mutualFollow'] as bool?
      // ..isFollow = json['isFollow'] as bool?
      ..isFollowedCd = (json['isFollowedCd'] as num?)?.toInt();

Map<String, dynamic> _$FollowInfoModelToJson(FollowInfoModel instance) =>
    <String, dynamic>{
      'followMemberId': instance.followMemberId,
      'followNickName': instance.followNickName,
      'followImagePath': instance.followImagePath,
      'mutualFollow': instance.mutualFollow,
      // 'isFollow': instance.isFollow,
      'isFollowedCd': instance.isFollowedCd,
    };
