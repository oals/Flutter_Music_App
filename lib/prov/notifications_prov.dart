import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:skrrskrr/model/notifications/notifications_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/utils/helpers.dart';
import 'package:http/http.dart' as http;

class NotificationsProv extends ChangeNotifier{

  NotificationsModel model = NotificationsModel();
  bool notificationsIsView = false;

  void notify() {
    notifyListeners();
  }

  void setNotificationsIsView(bool isView){
    notificationsIsView = isView;
    notify();
  }

  Future<bool> setDelNotificationIsView() async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setDelNotificationIsView';

    try {
      http.Response response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body: {
            'loginMemberId' : loginMemberId,
          }
        );

      if (response.statusCode == 200) {

        setNotificationsIsView(false);

        print('$url - Successful');
        return true;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> setAllNotificationIsView() async {
    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setAllNotificationIsView';

    try {
      http.Response response = await Helpers.apiCall(
          url,
          method : "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body:{
            'loginMemberId' : loginMemberId,
          },
        );

      if (response.statusCode == 200) {

        setNotificationsIsView(false);

        print('$url - Successful');
        return true;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> setNotificationIsView(int notificationId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setNotificationIsView';

    try {
      http.Response response = await Helpers.apiCall(
            url,
            method: "POST",
            headers: {
              'Content-Type': 'application/json',
            },
            body:{
              'notificationId': notificationId,
              'loginMemberId' : loginMemberId,
            },
        );

      if (response.statusCode == 200) {

        setNotificationsIsView(Helpers.extractValue(response.body, "notificationIsView"));

        print('$url - Successful');
        return true;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }


  Future<bool> getNotifications(offset) async {

    String loginMemberId = await Helpers.getMemberId();

    final url = '/api/getNotifications?loginMemberId=${loginMemberId}&limit=${20}&offset=${offset}';

    try {
      http.Response response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {

        if (offset == 0) {
          model = NotificationsModel();
        }

        for (var item in Helpers.extractValue(response.body, 'notificationList')) {
          model.notificationList.add(NotificationsModel.fromJson(item));
        }

        model.totalCount = Helpers.extractValue(response.body, 'totalCount');

        print('$url - Successful');
        return true;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  // 전체 알림이 비어있는지 체크하는 함수
  bool checkNotificationExistence(List notificationList) {
    return notificationList.isNotEmpty;
  }

  // 리스트에서 하나라도 notificationIsView가 true인 것이 있는지 체크하는 함수
  bool checkNotificationIsViewExistence(List notificationsList) {
    for (var notification in notificationsList) {
      if (notification.notificationIsView != null && !notification.notificationIsView!) {
        return true;
      }
    }
    return false;
  }

  Future<void> moveNotification(NotificationsModel notificationItem,BuildContext context) async {

    if (!notificationItem.notificationIsView!) {
      await setNotificationIsView(notificationItem.notificationId!);
      notificationItem.notificationIsView = true;
      notify();
    }

    if (notificationItem.notificationType == 1) {

      Track track = Track();
      track.trackId = notificationItem.notificationTrackId;
      GoRouter.of(context).push('/trackInfo',
        extra: {
          'track': track,
          'commendId': null,
        },
      );

    } else if (notificationItem.notificationType == 2) {

      Track track = Track();
      track.trackId = notificationItem.notificationTrackId;
      GoRouter.of(context).push('/trackInfo',
        extra: {
          'track': track,
          'commendId': notificationItem.notificationCommentId
        },
      );

    } else if (notificationItem.notificationType == 3) {
      GoRouter.of(context).push('/memberPage/${notificationItem.notificationMemberId}');
    }
  }
}