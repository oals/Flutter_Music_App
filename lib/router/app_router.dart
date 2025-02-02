import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/screen/appScreen/album/my_album_screen.dart';
import 'package:skrrskrr/screen/appScreen/feed/Feed.dart';
import 'package:skrrskrr/screen/appScreen/category/category.dart';
import 'package:skrrskrr/screen/appScreen/follow/follow.dart';
import 'package:skrrskrr/screen/appScreen/playlist/my_play_list.dart';
import 'package:skrrskrr/screen/appScreen/search/search.dart';
import 'package:skrrskrr/screen/home.dart';
import 'package:skrrskrr/screen/appScreen/comn/login.dart';
import 'package:skrrskrr/screen/modal/player.dart';
import 'package:skrrskrr/screen/appScreen/comn/more.dart';
import 'package:skrrskrr/screen/appScreen/track/music_info.dart';
import 'package:skrrskrr/screen/appScreen/track/my_like_track.dart';
import 'package:skrrskrr/screen/appScreen/notification/notification_screen.dart';
import 'package:skrrskrr/screen/appScreen/playlist/play_list.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting.dart';
import 'package:skrrskrr/screen/appScreen/comn/splash.dart';
import 'package:skrrskrr/screen/appScreen/track/upload_track.dart';
import 'package:skrrskrr/screen/appScreen/member/user_page.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_appbar_v2.dart';
import 'package:skrrskrr/screen/subScreen/comn/custom_bottom_navigation_bar.dart';
import 'package:skrrskrr/utils/helpers.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: HomeScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: LoginScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/feed',
      builder: (context, state) {
        return AppScreen(child: FeedScreen());
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        return AppScreen(child: SearchScreen());
      },
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) {
        return AppScreen(child: SettingScreen());
      },
    ),
    GoRoute(
      path: '/userPage/:memberId',
      pageBuilder: (context, state) {
        final memberId = int.parse(state.pathParameters['memberId']!);
        return CustomTransitionPage(
          child: AppScreen(child: UserPageScreen(memberId: memberId)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/musicInfo/:trackId',
      pageBuilder: (context, state) {
        final trackId = int.parse(state.pathParameters['trackId']!);
        return CustomTransitionPage(
          child: AppScreen(child: MusicInfoScreen(trackId: trackId)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/more/:moreId/:searchText/:totalCount',
      pageBuilder: (context, state) {
        final moreId = int.parse(state.pathParameters['moreId']!);
        final searchText = state.pathParameters['searchText']!;
        final totalCount = int.parse(state.pathParameters['totalCount']!);
        return CustomTransitionPage(
          child: AppScreen(child: MoreScreen(
              moreId: moreId,
              searchText: searchText,
              totalCount: totalCount)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/adminLikeTrack/:adminId',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: MyLikeTrackScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/adminPlayList/:adminId',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: MyPlayListScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/adminUploadTrack/:adminId',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: UploadTrackScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/adminFollow/:adminId',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: FollowScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/splash',

      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: SplashScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },

    ),
    GoRoute(
      path: '/adminAlbum/:adminId',
      pageBuilder: (context, state) {
        final adminId = int.parse(state.pathParameters['adminId']!);
        return CustomTransitionPage(
          child: AppScreen(child: MyAlbumScreen(adminId: adminId)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },

    ),
    GoRoute(
      path: '/playList/:playListId',
      pageBuilder: (context, state) {
        final playListId = int.parse(state.pathParameters['playListId']!);
        return CustomTransitionPage(
          child: AppScreen(child: PlayListScreen(playListId: playListId)),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },

    ),
    GoRoute(
      path: '/notification',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: NotificationScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/category/:categoryId',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: AppScreen(child: CategoryScreen()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
  ],
);

class AppScreen extends StatefulWidget {
  final Widget child;

  AppScreen({required this.child});

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;
  bool isFullScreen = false;
  bool isPlaying = false;
  bool isLeading = false;
  PageController _pageController = PageController();
  int _currentPage = 0;

  final ValueNotifier<Widget> _childNotifier =
      ValueNotifier<Widget>(Container());

  @override
  void initState() {
    _childNotifier.value = widget.child; // 초기 child 설정
    _pageController.addListener(() {
      int newPage = _pageController.page!.round();
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });

    super.initState();
  }

  void isFullScreenFunc(bool isFullScreenVal) {
    setState(() {
      isFullScreen = isFullScreenVal;
    });
  }

  void isPlayingFunc(bool isPlayingVal) {
    isPlaying = isPlayingVal;
  }

  @override
  void didUpdateWidget(covariant AppScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // child가 변경될 때만 값 업데이트
    if (oldWidget.child != widget.child) {
      _childNotifier.value = widget.child;
    }
  }

  List<String> testAudioPathList = [
    'audios/testAudio.mp3',
    'audios/testAudio2.mp3',
    'audios/testAudio3.mp3'
  ];

  @override
  Widget build(BuildContext context) {
    double _height = isFullScreen ? 100.h : 80;
    bool showBottomNav =
        !(widget.child is SplashScreen || widget.child is LoginScreen);

    bool showAppbar =
        isFullScreen || !(widget.child is HomeScreen || widget.child is SettingScreen);

    return Scaffold(
      appBar: !showAppbar
          ? CustomAppbarV2(isNotification: true) : null,

      body: Stack(
        children: [
          ValueListenableBuilder<Widget>(
            valueListenable: _childNotifier,
            builder: (context, child, childWidget) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 700), // 애니메이션 지속 시간
                child: child,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                      opacity: animation, child: child); // 페이드 애니메이션
                },
              );
            },
          ),
          if (showBottomNav)
            Positioned(
              left: 0,
              right: 0,
              bottom: 2,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PageView(
                  controller: _pageController,
                  children: [
                    PlayerScreen(
                      isFullScreenFunc: isFullScreenFunc,
                      playerHeight: _height,
                      isFullScreen: isFullScreen,
                      audioPath: testAudioPathList[0],
                      isPlayingFunc: isPlayingFunc,
                      isPlaying: isPlaying,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: showBottomNav & !isFullScreen
          ? CustomBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  // 화면 전환
                  if (index == 0) {
                    context.replace('/');
                  } else if (index == 1) {
                    context.replace('/feed');
                  } else if (index == 2) {
                    context.replace('/search');
                  } else if (index == 3) {
                    context.replace('/setting');
                  }
                });
              },
            )
          : null,
    );
  }
}
