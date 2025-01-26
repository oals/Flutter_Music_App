import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/firebase_options.dart';
import 'package:skrrskrr/prov/auth_prov.dart';
import 'package:skrrskrr/prov/category_prov.dart';
import 'package:skrrskrr/prov/comment_prov.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/home_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/router/app_router.dart';


import 'package:skrrskrr/utils/permissions.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "env/config.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions,  // FirebaseOptions 설정
  );
  FcmNotifications.initializeNotification();  // Firebase 알림 초기화

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProv()),
        ChangeNotifierProvider(create: (context) => SearchProv()),
        ChangeNotifierProvider(create: (context) => AudioPlayerManager()),
        ChangeNotifierProvider(create: (context) => MemberProv()),
        ChangeNotifierProvider(create: (context) => TrackProv()),
        ChangeNotifierProvider(create: (context) => PlayListProv()),
        ChangeNotifierProvider(create: (context) => ImageProv()),
        ChangeNotifierProvider(create: (context) => CommentProv()),
        ChangeNotifierProvider(create: (context) => FollowProv()),
        ChangeNotifierProvider(create: (context) => NotificationsProv()),
        ChangeNotifierProvider(create: (context) => CategoryProv()),
        ChangeNotifierProvider(create: (context) => AuthProv()),
      ],
      child: const MyApp(),
    ),
  );

  Permissions.requestNotificationPermission();  // 알림 권한 요청
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(  // 화면 크기 자동 조정
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          routerConfig: router,
          title: 'go_router',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
