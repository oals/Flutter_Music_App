import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/model/notifications/notifications_model.dart';
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
        model = NotificationsModel();

        for (var item in Helpers.extractValue(response.body, 'todayNotificationList')) {
          model.todayNotificationsList.add(NotificationsModel.fromJson(item));
        }

        for (var item in Helpers.extractValue(response.body, 'monthNotificationList')) {
          model.monthNotificationsList.add(NotificationsModel.fromJson(item));
        }

        for (var item in Helpers.extractValue(response.body, 'yearNotificationList')) {
          model.yearNotificationsList.add(NotificationsModel.fromJson(item));
        }

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
}