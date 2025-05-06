

import 'package:json_annotation/json_annotation.dart';

part 'notifications_model.g.dart'; // 생성될 파일

@JsonSerializable()
class NotificationsModel {

  int? notificationId;

  int? notificationType;

  String? notificationMsg;

  String? notificationDate;

  bool? notificationIsView;

  int? notificationTrackId;

  int? notificationMemberId;

  int? notificationCommentId;

  String? memberImagePath;

  @JsonKey(includeFromJson: false, includeToJson: false)
  int? totalCount;

  List<NotificationsModel> notificationList = [];

  NotificationsModel();

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => _$NotificationsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);

}