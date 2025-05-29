
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/notifications/notifications_model.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/router/app_router_config.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class FcmNotifications{


  static Future<String?> getMyDeviceToken() async { // 디바이스에 설정된 토큰 가져오기
    final token = await FirebaseMessaging.instance.getToken();
    print("내 디바이스 토큰: $token");
    return token;

  }

  static void FcmBackgroundDeepLink(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fcmBackgroundMessage = await prefs.getString('fcmBackgroundMessage') ?? "";

    if (fcmBackgroundMessage != "") {
      NotificationsModel notificationsModel = NotificationsModel.fromJson(jsonDecode(fcmBackgroundMessage.toString()));

      Future.delayed(Duration(milliseconds: 700), () async {
        Provider.of<NotificationsProv>(context,listen: false).moveNotification(notificationsModel,context);
      });

      await prefs.remove('fcmBackgroundMessage');
    }
  }

  /**
   * Firebase Cloud Messaging(FCM)을 사용하여 푸시 알림을 처리
   * Flutter Local Notifications를 사용하여 알림을 화면에 표시
   *
   * Firebase Cloud Messaging(FCM)을 사용하여 푸시 알림을 처리하고,
   * Flutter Local Notifications를 사용하여 알림을 화면에 표시하는 설정을 담당
   */
  static void initializeNotification(BuildContext context) async {

    /** fcm에서 받은 메시지를 화면에 표시하기 위함
     * 이 객체를 통해 알림 채널을 설정, 초기화, 알림 표시 등 작업
     * */
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
          /** Android 플랫폼에 특화된 기능을 사용할 수 있게 해줌 */
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        /** 안드로이드에서는 알림을 채널 단위로 관리 */
        ?.createNotificationChannel(
        const AndroidNotificationChannel(
            'high_importance_channel',  /** 알림 채널 설정*/
            'high_importance_notification', /** 알림 채널 설명 */
            importance: Importance.max    /** 알림 채널 중요도  */
        ));


    /**로컬 알림을 초기화 하는 메서드
     *  알림을 표시하기 전에 꼭 초기화를 해야함
     * */

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"), /** 알림에 표시 될 아이콘 */
      ),
      onSelectNotification: (String? payload) async {
        print("🔔 알림 클릭됨! Payload: $payload");

        NotificationsModel notificationsModel = NotificationsModel.fromJson(jsonDecode(payload!));

        if (GoRouter.of(navigatorKey.currentContext!).canPop()) {
          await AppBottomModalRouter().removeOverlay(null);
        }

        Future.delayed(Duration(milliseconds: 700), () async {
          Provider.of<NotificationsProv>(context,listen: false).moveNotification(notificationsModel,navigatorKey.currentContext!);
        });
      
      },
    );


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {

      print("🔔 백그라운드/종료 후 ${message.notification!.body}");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcmBackgroundMessage', message.notification!.body.toString() );

    });

    /** 포그라운드 살태일 때 푸시 알림을 어떻게 표시할지 설정*/
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, /** 알림을 화면에 띄울 지*/
      badge: true, /** 앱 아이콘에 배지를 표시할 지 */
      sound: true, /** 알림 소리를 울릴 지 여부 */
    );

    firebaseMessagingForegroundHandler(context);

    /** 백그라운드에서 메시지를 받을 때 호출 할 백그라운드 이벤트 리스너 설정*/
    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler /** 메서드 전달 */
    );
  }

  /** 백그라운드 이벤트 리스너*/
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    try {
      // 메시지의 제목과 본문 추출
      RemoteNotification? notification = message.notification;

      print("백그라운드 메시지 처리 중...");

      // 메시지 데이터 확인
      if (message.data.isNotEmpty) {
        print("메시지 데이터: ${message.data}");
      }

      // 로컬 알림 생성 (flutter_local_notifications 활용)
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode, // 알림의 고유 id
        notification?.title,
        notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'high_importance_notification',
            importance: Importance.max,
            color: Colors.black54, // 알림 아이콘 색상 설정 (배경 색상은 따로 스타일로 설정)
            category: 'category_alert',
          ),
        ),
      );


    } catch (e) {
      print("백그라운드 메시지 처리 중 오류 발생: $e");
    }
  }

  /** 포그라운드 이벤트 리스너 */
  static void firebaseMessagingForegroundHandler(BuildContext context) async {

    /** 포그라운드 푸시 알림이 왔을 때 실행 되는 이벤트 리스너 */
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      /** message(알림메시지)에서 푸시 알림에 대한 정보 가져옴 */
      RemoteNotification? notification = message.notification;
      /** 알림이 존재하면 */
      if (notification != null) {

        /**
         * 로컬 알림을 표시하기 위한 객체를 생성
         * fcm에서 수신한 푸시 메시지를 화면에 표시하는 데 사용됨
         * 앱 전체에서 한번만 선언되도록 변경해야함
         * */
        final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        String rawBody = notification.body.toString(); // JSON 형식의 body 데이터
        Map<String, dynamic> bodyMap = jsonDecode(rawBody); // JSON을 Map으로 변환

        /** 푸시 알림을 화면에 표시*/
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode, // 알림의 고유 id
          notification.title, // 알림의 제목
          bodyMap["body"] , // 알림의 내용
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
              color: Colors.black54, // 알림 아이콘 색상 설정 (배경 색상은 따로 스타일로 설정)
              category: 'category_alert',
            ),
          ),
          payload: rawBody
        );

        print("Foreground 메시지 수신: ${message.notification?.toMap()}");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notificationsIsView', true);
        Provider.of<NotificationsProv>(context, listen: false).sharedSaveNotificationsIsView();

      }
    });


  }




}