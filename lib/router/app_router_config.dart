import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/track/track.dart';

import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/router/app_screen.dart';

import 'package:skrrskrr/screen/appScreen/album/my_album_screen.dart';
import 'package:skrrskrr/screen/appScreen/category/category_screen.dart';
import 'package:skrrskrr/screen/appScreen/login/login_screen.dart';
import 'package:skrrskrr/screen/appScreen/comn/more_screen.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';
import 'package:skrrskrr/screen/appScreen/feed/feed_screen.dart';
import 'package:skrrskrr/screen/appScreen/follow/follow_screen.dart';
import 'package:skrrskrr/screen/appScreen/home/home_screen.dart';
import 'package:skrrskrr/screen/appScreen/member/user_page_screen.dart';
import 'package:skrrskrr/screen/appScreen/notification/notification_screen.dart';
import 'package:skrrskrr/screen/appScreen/playlist/my_play_list_screen.dart';
import 'package:skrrskrr/screen/appScreen/playlist/play_list_screen.dart';
import 'package:skrrskrr/screen/appScreen/search/search_screen.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting_screen.dart';
import 'package:skrrskrr/screen/appScreen/track/music_info_screen.dart';
import 'package:skrrskrr/screen/appScreen/track/my_like_track_screen.dart';
import 'package:skrrskrr/screen/appScreen/track/upload_track_screen.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Page commonPageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget pageWidget,
    {required bool isShowAudioPlayer}
    ) {

  final AppProv appProv = Provider.of<AppProv>(context);
  appProv.appScreenWidget = pageWidget;

  return CustomTransitionPage(
    child: AppScreen(
      child: pageWidget,
      isShowAudioPlayer: isShowAudioPlayer,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}


final router = GoRouter(
    initialLocation: '/splash',
    navigatorKey: navigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;
      print('네비게이션 이동 추적 : ' + location);
      return location; // 리디렉션하지 않음
    },
    routes: [

      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) {
          return commonPageBuilder(
            context,
            state,
            SplashScreen(),
            isShowAudioPlayer: true,
          );

        },
      ),

      GoRoute(
        path: '/home/:isShowAudioPlayer',
        pageBuilder: (context, state) {

          final String isShowAudioPlayerStr = state.pathParameters['isShowAudioPlayer'] ?? 'false';
          final bool isShowAudioPlayer = isShowAudioPlayerStr.toLowerCase() == 'true';

          return commonPageBuilder(
            context,
            state,
            HomeScreen(),
            isShowAudioPlayer: isShowAudioPlayer,
          );
        },
      ),

      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            LoginScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/feed',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            FeedScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/search',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            SearchScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/setting',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            SettingScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/userPage/:memberId',
        pageBuilder: (context, state) {
          final memberId = int.parse(state.pathParameters['memberId']!);

          return commonPageBuilder(
            context,
            state,
            UserPageScreen(memberId: memberId),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/musicInfo',
        pageBuilder: (context, state) {
          final Track track = state.extra as Track;

          return commonPageBuilder(
            context,
            state,
            MusicInfoScreen(track: track),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/more/:moreId/:searchText/:memberId/:totalCount',
        pageBuilder: (context, state) {
          final moreId = int.parse(state.pathParameters['moreId']!);
          final searchText = state.pathParameters['searchText']!;
          final memberId = state.pathParameters['memberId']!;
          final totalCount = int.parse(state.pathParameters['totalCount']!);

          return commonPageBuilder(
            context,
            state,
            MoreScreen(
                moreId: moreId,
                searchText: searchText,
                totalCount: totalCount,
                memberId: memberId),
            isShowAudioPlayer: true,
          );
        },
      ),


      GoRoute(
        path: '/adminLikeTrack/:adminId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            MyLikeTrackScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/adminPlayList/:adminId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            MyPlayListScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/adminUploadTrack/:adminId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            UploadTrackScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),


      GoRoute(
        path: '/adminFollow/:adminId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            FollowScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/adminAlbum/:adminId',
        pageBuilder: (context, state) {
          final adminId = int.parse(state.pathParameters['adminId']!);

          return commonPageBuilder(
            context,
            state,
            MyAlbumScreen(adminId: adminId),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/playList',
        pageBuilder: (context, state) {
          final PlayListInfoModel playList = state.extra as PlayListInfoModel;

          return commonPageBuilder(
            context,
            state,
            PlayListScreen(playList: playList),
            isShowAudioPlayer: true,
          );
        },
      ),


      GoRoute(
        path: '/notification',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            NotificationScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/category/:categoryId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            CategoryScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

    ],
  );



