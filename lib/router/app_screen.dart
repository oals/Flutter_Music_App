import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/appScreen/feed/feed_screen.dart';
import 'package:skrrskrr/screen/appScreen/search/search_screen.dart';
import 'package:skrrskrr/screen/appScreen/home/home_screen.dart';
import 'package:skrrskrr/screen/modal/new_player.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting_screen.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar_v2.dart';
import 'package:skrrskrr/screen/subScreen/comn/bottomNavigatorBar/custom_audio_player_bottom_navigation.dart';
import 'package:skrrskrr/screen/subScreen/comn/bottomNavigatorBar/custom_bottom_navigation_bar.dart';



class AppScreen extends StatefulWidget {
  late final Widget child;
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
  OverlayEntry? _overlayEntry = null;

  final ValueNotifier<Widget> _childNotifier = ValueNotifier<Widget>(Container());

  @override
  void initState() {
    super.initState();
    _childNotifier.value = widget.child; // 초기 child 설정
    _overlayEntry = _createOverlay();
  }

  OverlayEntry? _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        bool isHideAudioPlayer = appProv.isHideAudioPlayer(appProv.appScreenWidget);

        return isHideAudioPlayer
            ? Container()
            : Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5.4.h,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 440),
                    height: appProv.isFullScreen ? 100.h : 10.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.topCenter,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: appProv.hlsNotifier,
                      builder: (context, value, child) {
                        return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 440),
                            child: HLSStreamPage(
                              key: ValueKey<bool>(value),
                            )
                        );
                      },
                    )
                  ),
                ),
              ],
            );
      },
    );
  }


  void showOverlayIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.isShowAudioPlayer && _overlayEntry != null) {
        Overlay.of(context).insert(_overlayEntry!);
        _overlayEntry = null;
      }
    });
  }


  @override
  void didUpdateWidget(covariant AppScreen oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (oldWidget.child is SplashScreen && _childNotifier.value is! HomeScreen) {
      _childNotifier.value = HomeScreen();
    }

    if (widget.child == appProv.appScreenWidget ) {
      _childNotifier.value = widget.child;
      showOverlayIfNeeded();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showOverlayIfNeeded();
  }



  @override
  Widget build(BuildContext context) {

    appProv = Provider.of<AppProv>(context);

    bool showAppbar = appProv.isShowAppbar(appProv.appScreenWidget);
    bool showBottomNav = appProv.isShowBottomNav(appProv.appScreenWidget);


    return Scaffold(
      appBar: !appProv.isFullScreen && !showAppbar ? CustomAppbarV2(isNotification: true) : null,
      body: Stack(
        children: [
          ValueListenableBuilder<Widget>(
            valueListenable: _childNotifier,
            builder: (context, child, childWidget) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 700), // 애니메이션 지속 시간
                child: _childNotifier.value,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                      opacity: animation, child: child); // 페이드 애니메이션
                },
              );
            },
          ),


        ],
      ),
        bottomNavigationBar: AnimatedSwitcher(
          duration: const Duration(milliseconds: 700), // 애니메이션 지속 시간
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: showBottomNav ? CustomBottomNavigationBar(
            currentIndex: appProv.currentIndex,
            onTap: (index) {
              appProv.currentIndex = index;
              // 화면 전환 로직
              if (index == 0) {
                context.go('/home/${true}');
              } else if (index == 1) {
                appProv.appScreenWidget = FeedScreen();
                context.go('/feed');
              } else if (index == 2) {
                appProv.appScreenWidget = SearchScreen();
                context.go('/search');
              } else if (index == 3) {
                appProv.appScreenWidget = SettingScreen();
                context.go('/setting');
              }
              appProv.notify();
            },
          ) :
          appProv.isFullScreen ? CustomAudioPlayerBottomNavigation(
            currentIndex: appProv.currentIndex,
            onTap: (index) {
              appProv.currentIndex = index;
              // 화면 전환 로직
              if (index == 0) {
                print('트랙 좋아요');
              } else if (index == 1) {
                print('댓글 팝업');
                AppBottomModalRouter.fnModalRouter(context, 0, trackId: 3,);

              } else if (index == 2) {
                print("플리 팝업");
              } else if (index == 3) {
                print("곡 상세정보");
                // AppBottomModalRouter.fnModalRouter(context, 3, trackId: 3);
              }

            },
          ) : SizedBox(),
        ),
    );
  }
}
