// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayListModel _$PlayListModelFromJson(Map<String, dynamic> json) =>
    PlayListModel()
      ..playListNm = json['playListNm'] as String?
      ..playListImagePath = json['playListImagePath'] as String?
      ..playListId = (json['playListId'] as num?)?.toInt()
      ..memberId = (json['memberId'] as num?)?.toInt()
      ..memberNickName = json['memberNickName'] as String?
      ..isPlayListPrivacy = json['isPlayListPrivacy'] as bool?
      ..isInPlayList = json['isInPlayList'] as bool?
      ..playListLike = json['playListLike'] as bool?
      ..trackCnt = (json['trackCnt'] as num?)?.toInt();

Map<String, dynamic> _$PlayListModelToJson(PlayListModel instance) =>
    <String, dynamic>{
      'playListNm': instance.playListNm,
      'playListImagePath': instance.playListImagePath,
      'playListId': instance.playListId,
      'memberId': instance.memberId,
      'memberNickName': instance.memberNickName,
      'isPlayListPrivacy': instance.isPlayListPrivacy,
      'isInPlayList': instance.isInPlayList,
      'playListLike': instance.playListLike,
      'trackCnt': instance.trackCnt,
    };
