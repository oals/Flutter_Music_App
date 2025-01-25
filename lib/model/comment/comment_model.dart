

import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';
@JsonSerializable()
class CommentModel {

  int? commentId;

  int? memberId;

  int? trackId;

  String? memberImagePath;

  String? memberNickName;

  bool? commentLikeStatus;

  int? commentLikeCnt;

  String? commentText;

  String? commentDate;

  int? parentCommentId;

  bool? childCommentActive;

  List<CommentModel>? childComment = [];

  CommentModel();

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

}