import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/screen/appScreen/feed/feed_screen.dart';
import 'package:skrrskrr/screen/appScreen/search/search_screen.dart';
import 'package:skrrskrr/screen/appScreen/home/home_screen.dart';
import 'package:skrrskrr/screen/modal/new_player.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting_screen.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar_v2.dart';
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
            : IgnorePointer(
              ignoring: appProv.isOpenBottomModal,
              child: Opacity(
                  opacity: appProv.isOpenBottomModal ? 0 : 1,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: appProv.isFullScreen ? 0 : 60,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: appProv.isFullScreen ? 100.h : 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IndexedStack(
                            alignment : AlignmentDirectional.center,
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
                    ],
                  ),
                      ),
            );
      },
    );
  }


  @override
  void didUpdateWidget(covariant AppScreen oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (oldWidget.child is SplashScreen && widget.child is! HomeScreen) {
      // 상태를 변경하여 child 위젯을 업데이트
      _childNotifier.value = HomeScreen();
    }

    if (widget.child == appProv.appScreenWidget) {
      _childNotifier.value = widget.child;
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
        if (!widget.isShowAudioPlayer && _overlayEntry != null) {
          Overlay.of(context).insert(_overlayEntry!);
          _overlayEntry = null;
        }
      });
  }


  @override
  Widget build(BuildContext context) {

    appProv = Provider.of<AppProv>(context);

    bool showAppbar = appProv.isShowAppbar(appProv.appScreenWidget);
    bool showBottomNav = appProv.isShowBottomNav(appProv.appScreenWidget);

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
      bottomNavigationBar: showBottomNav & !appProv.isFullScreen
          ? CustomBottomNavigationBar(
              currentIndex: appProv.currentIndex,
              onTap: (index) {
                  appProv.currentIndex = index;
                  // 화면 전환
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
            )
          : null,
    );
  }
}
