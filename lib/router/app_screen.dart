import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/player/player.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/player_prov.dart';
import 'package:skrrskrr/screen/appScreen/album/my_album_screen.dart';
import 'package:skrrskrr/screen/appScreen/feed/Feed.dart';
import 'package:skrrskrr/screen/appScreen/category/category.dart';
import 'package:skrrskrr/screen/appScreen/follow/follow.dart';
import 'package:skrrskrr/screen/appScreen/playlist/my_play_list.dart';
import 'package:skrrskrr/screen/appScreen/search/search.dart';
import 'package:skrrskrr/screen/appScreen/home/home.dart';
import 'package:skrrskrr/screen/appScreen/comn/login.dart';
import 'package:skrrskrr/screen/modal/new_player.dart';
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


class AppScreen extends StatefulWidget {
  final Widget child;
  final bool isShowAudioPlayer;

  AppScreen({
    required this.child,
    required this.isShowAudioPlayer,
  });

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {

  late AppProv appProv;
  late PlayerProv playerProv;
  OverlayEntry? _overlayEntry = null;
  PageController _pageController = PageController();
  int _currentPage = 0;

  final ValueNotifier<Widget> _childNotifier = ValueNotifier<Widget>(Container());

  @override
  void initState() {
    print('appScreen initState');

    super.initState();
    _childNotifier.value = widget.child; // 초기 child 설정
    _overlayEntry = _createOverlay();


    // _pageController.addListener(() {
    //   int newPage = _pageController.page!.round();
    //   if (newPage != _currentPage) {
    //     _currentPage = newPage;
    //     setState(() {});
    //   }
    // });


  }



  OverlayEntry? _createOverlay() {
    return OverlayEntry(
      builder: (context) {

        bool isHideAudioPlayer = appProv.isHideAudioPlayer(appProv.testWidget);
        print("_createOverlay");
        print(appProv.testWidget);

        return Positioned(
          left: 0,
          right: 0,
          bottom: 60,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: appProv.isFullScreen ? 100.h : 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: IgnorePointer(
                ignoring: isHideAudioPlayer,
              child: Opacity(
                opacity: isHideAudioPlayer ? 0.0 : 1.0,
                child: IndexedStack(
                  index: 0,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: appProv.hlsNotifier,
                      builder: (context, value, child) {
                        return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 700),
                            child: HLSStreamPage(
                              key: ValueKey<bool>(value),
                            ) // 풀스크린 상태에서 페이지 변경
                        );

                      },
                    )

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  void didUpdateWidget(covariant AppScreen oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (oldWidget.child != widget.child) {

      WidgetsBinding.instance.addPostFrameCallback((_) {

        if (!widget.isShowAudioPlayer && _overlayEntry != null) {
          _overlayEntry = _createOverlay();
          Overlay.of(context).insert(_overlayEntry!);
          _overlayEntry = null;
        }
      });

    }





  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("didChangeDependencies");

        if (!widget.isShowAudioPlayer && _overlayEntry != null) {
          Overlay.of(context).insert(_overlayEntry!);
          _overlayEntry = null;
        }
      });


  }


  @override
  Widget build(BuildContext context) {

    appProv = Provider.of<AppProv>(context);

    bool showBottomNav = appProv.isShowBottomNav(appProv.testWidget);
    bool showAppbar = appProv.isShowAppbar(appProv.testWidget);

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
                child: appProv.testWidget,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                      opacity: animation, child: child); // 페이드 애니메이션
                },
              );
            },
          ),

          // if (showBottomNav)
          //   Positioned(
          //     left: 0,
          //     right: 0,
          //     bottom: 2,
          //     child: AnimatedContainer(
          //       duration: const Duration(milliseconds: 200),
          //       height: appProv.isFullScreen ? 100.h : 80,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: IndexedStack(
          //         index: 0,
          //         children: [
          //
          //         ValueListenableBuilder<bool>(
          //             valueListenable: appProv.hlsNotifier,
          //             builder: (context, value, child) {
          //               return AnimatedSwitcher(
          //                 duration: const Duration(milliseconds: 700),
          //                 child: HLSStreamPage(
          //                   key: ValueKey<bool>(value),
          //                 ) // 풀스크린 상태에서 페이지 변경
          //               );
          //             },
          //           )
          //
          //
          //           // HLSStreamPage(),
          //
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
      bottomNavigationBar: showBottomNav & !appProv.isFullScreen
          ? CustomBottomNavigationBar(
              currentIndex: appProv.currentIndex,
              onTap: (index) {
                  appProv.currentIndex = index;
                  // 화면 전환
                  if (index == 0) {
                    context.go('/home/${true}');
                  } else if (index == 1) {
                    appProv.testWidget = FeedScreen();
                    context.go('/feed');
                  } else if (index == 2) {
                    appProv.testWidget = SearchScreen();
                    context.go('/search');
                  } else if (index == 3) {
                    appProv.testWidget = SettingScreen();
                    context.go('/setting');
                  }
                  appProv.notify();

              },
            )
          : null,
    );
  }
}
