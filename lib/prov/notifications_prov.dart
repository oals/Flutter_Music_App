import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/model/notifications/notifications_model.dart';
import 'package:skrrskrr/utils/helpers.dart';
import 'package:http/http.dart' as http;

class NotificationsProv extends ChangeNotifier{


  NotificationsModel model = NotificationsModel();

  void notify() {
    notifyListeners();
  }



  Future<bool> setDelNotificationIsView() async {
    print('setDelNotificationIsView 호출');

    final String memberId = await Helpers.getMemberId();
    final url = 'setDelNotificationIsView';

    try {
      final response = await Helpers.apiCall(
          url,
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body: {
            'memberId' : memberId,
          }
        );


      if ((response != null)) {
        Helpers.setNotificationIsView(false);

      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }


  Future<bool> setAllNotificationisView() async {
    print('setAllNotificationisView 호출');

    final String memberId = await Helpers.getMemberId();
    final url = 'setAllNotificationisView';

    try {
      final response = await Helpers.apiCall(
          url,
          method : "POST",
          headers: {
            'Content-Type': 'application/json',
          },
          body:{
            'memberId' : memberId,
          },
        );

      if ((response != null)) {
        Helpers.setNotificationIsView(false);
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }



  Future<bool> setNotificationIsView(int notificationId) async {
    print('setNotificationIsView 호출');
    print(notificationId);

    final String memberId = await Helpers.getMemberId();
    final url = 'setNotificationIsView';

    try {
      final response = await Helpers.apiCall(
            url,
            method: "POST",
            headers: {
              'Content-Type': 'application/json',
            },
            body:{
              'notificationId': notificationId,
              'memberId' : memberId,
            },
        );

      if ((response != null)) {
        // 성공적으로 데이터를 가져옴

        Helpers.setNotificationIsView(response['notificationIsView']);

      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }


  Future<bool> getNotifications(listIndex) async {

    print("getNotifications");

    String memberId = await Helpers.getMemberId();

    final url = 'getNotifications?memberId=${memberId}&listIndex=${listIndex}';

    try {
      final response = await Helpers.apiCall(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if ((response != null)) {
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


      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('SearchTrack Error: $error');
      return false;
    }
    return true;
  }







}