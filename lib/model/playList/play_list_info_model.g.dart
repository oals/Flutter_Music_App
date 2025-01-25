// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_list_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayListInfoModel _$PlayListInfoModelFromJson(Map<String, dynamic> json) =>
    PlayListInfoModel()
      ..playListId = (json['playListId'] as num?)?.toInt()
      ..playListNm = json['playListNm'] as String?
      ..playListLikeCnt = (json['playListLikeCnt'] as num?)?.toInt()
      ..isPlayListPrivacy = json['isPlayListPrivacy'] as bool?
      ..playListImagePath = json['playListImagePath'] as String?
      ..isInPlayList = json['isInPlayList'] as bool?
      ..playListLike = json['playListLike'] as bool?
      ..totalPlayTime = json['totalPlayTime'] as String?
      ..trackCnt = (json['trackCnt'] as num?)?.toInt()
      ..playListTrackList = (json['playListTrackList'] as List<dynamic>?)
          ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList()
      ..memberId = (json['memberId'] as num?)?.toInt()
      ..memberNickName = json['memberNickName'] as String?;

Map<String, dynamic> _$PlayListInfoModelToJson(PlayListInfoModel instance) =>
    <String, dynamic>{
      'playListId': instance.playListId,
      'playListNm': instance.playListNm,
      'playListLikeCnt': instance.playListLikeCnt,
      'isPlayListPrivacy': instance.isPlayListPrivacy,
      'playListImagePath': instance.playListImagePath,
      'isInPlayList': instance.isInPlayList,
      'playListLike': instance.playListLike,
      'totalPlayTime': instance.totalPlayTime,
      'trackCnt': instance.trackCnt,
      'playListTrackList': instance.playListTrackList,
      'memberId': instance.memberId,
      'memberNickName': instance.memberNickName,
    };
