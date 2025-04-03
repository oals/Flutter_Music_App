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
      ..totalPlayTime = json['totalPlayTime'] as String?
      ..memberId = (json['memberId'] as num?)?.toInt()
      ..memberNickName = json['memberNickName'] as String?
      ..memberImagePath = json['memberImagePath'] as String?
      ..isPlayListPrivacy = json['isPlayListPrivacy'] as bool?
      ..isInPlayList = json['isInPlayList'] as bool?
      ..isPlayListLike = json['isPlayListLike'] as bool?
      ..trackCnt = (json['trackCnt'] as num?)?.toInt()
      ..playListLikeCnt = (json['playListLikeCnt'] as num?)?.toInt();

Map<String, dynamic> _$PlayListModelToJson(PlayListModel instance) =>
    <String, dynamic>{
      'playListNm': instance.playListNm,
      'playListImagePath': instance.playListImagePath,
      'playListId': instance.playListId,
      'memberId': instance.memberId,
      'memberNickName': instance.memberNickName,
      'memberImagePath': instance.memberImagePath,
      'totalPlayTime': instance.totalPlayTime,
      'isPlayListPrivacy': instance.isPlayListPrivacy,
      'isInPlayList': instance.isInPlayList,
      'isPlayListLike': instance.isPlayListLike,
      'trackCnt': instance.trackCnt,
      'playListLikeCnt': instance.playListLikeCnt,
    };
