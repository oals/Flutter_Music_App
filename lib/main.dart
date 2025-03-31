import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/firebase_options.dart';
import 'package:skrrskrr/model/player/player.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/auth_prov.dart';
import 'package:skrrskrr/prov/category_prov.dart';
import 'package:skrrskrr/prov/comment_prov.dart';
import 'package:skrrskrr/prov/follow_prov.dart';
import 'package:skrrskrr/prov/home_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/more_prov.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/router/app_screen.dart';
import 'package:skrrskrr/router/app_router_config.dart';


import 'package:skrrskrr/utils/permissions.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "env/config.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions,  // FirebaseOptions 설정
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProv()),
        ChangeNotifierProvider(create: (context) => HomeProv()),
        ChangeNotifierProvider(create: (context) => SearchProv()),
        ChangeNotifierProvider(create: (context) => PlayerProv()),
        ChangeNotifierProvider(create: (context) => MemberProv()),
        ChangeNotifierProvider(create: (context) => TrackProv()),
        ChangeNotifierProvider(create: (context) => PlayListProv()),
        ChangeNotifierProvider(create: (context) => ImageProv()),
        ChangeNotifierProvider(create: (context) => CommentProv()),
        ChangeNotifierProvider(create: (context) => FollowProv()),
        ChangeNotifierProvider(create: (context) => NotificationsProv()),
        ChangeNotifierProvider(create: (context) => CategoryProv()),
        ChangeNotifierProvider(create: (context) => AuthProv()),
        ChangeNotifierProvider(create: (context) => MoreProv()),
      ],
      child: const MyApp(),
    ),
  );

  Permissions.requestNotificationPermission();  // 알림 권한 요청
}


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FcmNotifications.initializeNotification(context);  // Firebase 알림 초기화
    print('메인 빌드');
    return ResponsiveSizer(  // 화면 크기 자동 조정
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          routerConfig: router(navigatorKey),
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
