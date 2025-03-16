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
    final url= '/api/setDelNotificationIsView';

    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body: {
            'loginMemberId' : loginMemberId,
          }
        );


      if (response['status'] == '200') {
        setNotificationsIsView(false);
        print('$url - Successful');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }

  }


  Future<bool> setAllNotificationIsView() async {
    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/setAllNotificationisView';

    try {
      final response = await Helpers.apiCall(
          url,
          method : "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body:{
            'loginMemberId' : loginMemberId,
          },
        );

      if (response['status'] == '200') {
        setNotificationsIsView(false);
        print('$url - Successful');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }
  }



  Future<bool> setNotificationIsView(int notificationId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/setNotificationIsView';

    try {
      final response = await Helpers.apiCall(
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

      if (response['status'] == '200') {
        setNotificationsIsView(response['notificationIsView']);
        print('$url - Successful');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }

  }


  Future<bool> getNotifications(listIndex) async {

    String loginMemberId = await Helpers.getMemberId();

    final url= '/api/getNotifications?loginMemberId=${loginMemberId}&listIndex=${listIndex}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response['status'] == '200') {
        // 성공적으로 데이터를 가져옴
        model = NotificationsModel();

        for(var item in response['todayNotificationsList']){
          model.todayNotificationsList.add(NotificationsModel.fromJson(item));
        }

        for(var item in response['monthNotificationsList']){
          model.monthNotificationsList.add(NotificationsModel.fromJson(item));
        }

        for(var item in response['yearNotificationsList']){
          model.yearNotificationsList.add(NotificationsModel.fromJson(item));
        }

        print('$url - Successful');
        return true;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$url - Fail');
      return false;
    }
  }

}