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
  ..parentCommentMemberId = (json['parentCommentMemberId'] as num?)?.toInt()
  ..parentCommentMemberNickName = json['parentCommentMemberNickName'] as String?
  ..commentLikeStatus = json['commentLikeStatus'] as bool?
  ..commentLikeCnt = (json['commentLikeCnt'] as num?)?.toInt()
  ..commentText = json['commentText'] as String?
  ..commentDate = json['commentDate'] as String?
  ..parentCommentId = (json['parentCommentId'] as num?)?.toInt()
  ..isChildCommentActive = json['isChildCommentActive'] as bool?
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
      'parentCommentMemberId': instance.parentCommentMemberId,
      'parentCommentMemberNickName': instance.parentCommentMemberNickName,
      'commentLikeStatus': instance.commentLikeStatus,
      'commentLikeCnt': instance.commentLikeCnt,
      'commentText': instance.commentText,
      'commentDate': instance.commentDate,
      'parentCommentId': instance.parentCommentId,
      'isChildCommentActive': instance.isChildCommentActive,
      'childComments': instance.childComments,
    };
