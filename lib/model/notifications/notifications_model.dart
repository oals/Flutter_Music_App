

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


  List<NotificationsModel> todayNotificationsList = [];
  List<NotificationsModel> monthNotificationsList = [];
  List<NotificationsModel> yearNotificationsList = [];

  NotificationsModel();

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => _$NotificationsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsModelToJson(this);

}