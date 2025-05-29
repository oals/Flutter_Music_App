// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel()
  ..commentId = (json['commentId'] as num?)?.toInt()
  ..memberId = (json['memberId'] as num?)?.toInt()
  ..trackId = (json['trackId'] as num?)?.toInt()
  ..memberImagePath = json['memberImagePath'] as String?
  ..memberNickName = json['memberNickName'] as String?
  ..commentLikeStatus = json['commentLikeStatus'] as bool?
  ..commentLikeCnt = (json['commentLikeCnt'] as num?)?.toInt()
  ..commentText = json['commentText'] as String?
  ..commentDate = json['commentDate'] as String?
  ..childComments = (json['childComments'] as List<dynamic>?)
      ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'commentId': instance.commentId,
      'memberId': instance.memberId,
      'trackId': instance.trackId,
      'memberImagePath': instance.memberImagePath,
      'memberNickName': instance.memberNickName,
      'commentLikeStatus': instance.commentLikeStatus,
      'commentLikeCnt': instance.commentLikeCnt,
      'commentText': instance.commentText,
      'commentDate': instance.commentDate,
      'childComments': instance.childComments,
    };
