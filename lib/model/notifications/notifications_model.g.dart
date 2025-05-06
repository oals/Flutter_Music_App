// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationsModel _$NotificationsModelFromJson(Map<String, dynamic> json) =>
    NotificationsModel()
      ..notificationId = (json['notificationId'] as num?)?.toInt()
      ..notificationType = (json['notificationType'] as num?)?.toInt()
      ..notificationMsg = json['notificationMsg'] as String?
      ..memberImagePath = json['memberImagePath'] as String?
      ..notificationDate = json['notificationDate'] as String?
      ..notificationIsView = json['notificationIsView'] as bool?
      ..notificationTrackId = (json['notificationTrackId'] as num?)?.toInt()
      ..notificationMemberId = (json['notificationMemberId'] as num?)?.toInt()
      ..notificationCommentId = (json['notificationCommentId'] as num?)?.toInt();

Map<String, dynamic> _$NotificationsModelToJson(NotificationsModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'notificationType': instance.notificationType,
      'notificationMsg': instance.notificationMsg,
      'notificationDate': instance.notificationDate,
      'memberImagePath': instance.memberImagePath,
      'notificationIsView': instance.notificationIsView,
      'notificationTrackId': instance.notificationTrackId,
      'notificationMemberId': instance.notificationMemberId,
      'notificationCommentId': instance.notificationCommentId,
    };
