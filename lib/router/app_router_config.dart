import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/router/app_screen.dart';
import 'package:skrrskrr/screen/appScreen/album/like_album_screen.dart';
import 'package:skrrskrr/screen/appScreen/category/category_screen.dart';
import 'package:skrrskrr/screen/appScreen/login/login_screen.dart';
import 'package:skrrskrr/screen/appScreen/album/member_album_screen.dart';
import 'package:skrrskrr/screen/appScreen/playlist/member_playlist_screen.dart';
import 'package:skrrskrr/screen/appScreen/search/search_member_screen.dart';
import 'package:skrrskrr/screen/appScreen/search/search_playlist_screen.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';
import 'package:skrrskrr/screen/appScreen/feed/feed_screen.dart';
import 'package:skrrskrr/screen/appScreen/follow/member_follow_screen.dart';
import 'package:skrrskrr/screen/appScreen/home/home_screen.dart';
import 'package:skrrskrr/screen/appScreen/member/member_page_screen.dart';
import 'package:skrrskrr/screen/appScreen/notification/notification_screen.dart';
import 'package:skrrskrr/screen/appScreen/playlist/like_playlist_screen.dart';
import 'package:skrrskrr/screen/appScreen/playlist/playlist_screen.dart';
import 'package:skrrskrr/screen/appScreen/search/search_screen.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting_screen.dart';
import 'package:skrrskrr/screen/appScreen/track/track_info_screen.dart';
import 'package:skrrskrr/screen/appScreen/track/like_track_screen.dart';
import 'package:skrrskrr/screen/appScreen/track/upload_track_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Page commonPageBuilder(
      BuildContext context,
      GoRouterState state,
      Widget pageWidget,
      {
        required bool isShowAudioPlayer
      }
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
      return location;
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
        path: '/memberPage/:memberId',
        pageBuilder: (context, state) {
          final memberId = int.parse(state.pathParameters['memberId']!);

          return commonPageBuilder(
            context,
            state,
            MemberPageScreen(memberId: memberId),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/trackInfo',
        pageBuilder: (context, state) {

          final Map<String, dynamic> extraData = state.extra as Map<String, dynamic>;
          final Track track = extraData['track'] as Track;
          final int? commentId = extraData['commendId'] as int?;

          return commonPageBuilder(
            context,
            state,
            TrackInfoScreen(track: track,commentId: commentId,),
            isShowAudioPlayer: true,
          );
        },
      ),


      GoRoute(
        path: '/searchMember/:searchText',
        pageBuilder: (context, state) {
          final searchText = state.pathParameters['searchText']!;

          return commonPageBuilder(
            context,
            state,
            SearchMemberScreen(searchText: searchText),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/SearchPlayList/:searchText',
        pageBuilder: (context, state) {
          final searchText = state.pathParameters['searchText']!;

          return commonPageBuilder(
            context,
            state,
            SearchPlaylistScreen(searchText: searchText),
            isShowAudioPlayer: true,
          );
        },
      ),


      GoRoute(
        path: '/memberPlayList/:memberId',
        pageBuilder: (context, state) {
          final memberId = int.parse(state.pathParameters['memberId']!);

          return commonPageBuilder(
            context,
            state,
            MemberPlaylistScreen(memberId: memberId,),
            isShowAudioPlayer: true,
          );
        },
      ),


      GoRoute(
        path: '/memberAlbums/:memberId',
        pageBuilder: (context, state) {
          final memberId = int.parse(state.pathParameters['memberId']!);

          return commonPageBuilder(
            context,
            state,
            MemberAlbumScreen(memberId: memberId,),
            isShowAudioPlayer: true,
          );
        },
      ),


      GoRoute(
        path: '/likeTrack/:adminId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            LikeTrackScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/likePlayList/:adminId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            LikePlaylistScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/uploadTrack/:adminId',
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
        path: '/memberFollow/:adminId',
        pageBuilder: (context, state) {

          return commonPageBuilder(
            context,
            state,
            MemberFollowScreen(),
            isShowAudioPlayer: true,
          );
        },
      ),

      GoRoute(
        path: '/likeAlbum/:adminId',
        pageBuilder: (context, state) {
          final adminId = int.parse(state.pathParameters['adminId']!);

          return commonPageBuilder(
            context,
            state,
            LikeAlbumScreen(adminId: adminId),
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
            PlaylistScreen(playList: playList),
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



