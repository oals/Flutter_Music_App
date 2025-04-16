import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
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
            AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  left: 0,
                  right: 0,
                  bottom: !appProv.isFullScreen ? 5.5.h : 0, // 위치를 애니메이션으로 변경
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 700),
                    opacity: appProv.isFullScreen ? 1.0 : 0.85,  // 투명도 애니메이션 적용
                    curve: Curves.easeInOut,
                    child:  AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      height: appProv.isFullScreen ? 100.h : 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: appProv.isFullScreen ? 100.h : 10.h,
                        alignment: Alignment.topCenter,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 700),
                          child: HLSStreamPage(),
                        ),
                      ),
                    ),
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
      appBar: !showAppbar ? CustomAppbarV2(isNotification: true) : null,

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
          child: showBottomNav && !appProv.isFullScreen ? CustomBottomNavigationBar(
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
          ) : SizedBox(),
        ),
    );
  }
}
