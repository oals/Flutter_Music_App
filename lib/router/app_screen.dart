import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/screen/appScreen/feed/feed_screen.dart';
import 'package:skrrskrr/screen/appScreen/search/search_screen.dart';
import 'package:skrrskrr/screen/modal/audioPlayer/audio_player_modal.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting_screen.dart';
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
    _childNotifier.value = widget.child;
    _overlayEntry = _createOverlay();
  }

  OverlayEntry? _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        bool isHideAudioPlayer = appProv.isHideAudioPlayer(appProv.appScreenWidget);

        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: !appProv.isFullScreen ? 5.5.h : 0,
              child: IgnorePointer(
                ignoring: !isHideAudioPlayer? false : true,
                child: Opacity(
                  // duration: const Duration(milliseconds: 10),
                  opacity: !isHideAudioPlayer? appProv.isFullScreen ? 1.0 : 0.85 : 0.0,
                  // curve: Curves.easeInOut,
                  child: AnimatedContainer(
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
                        child: AudioPlayerModal(),
                      ),
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
                duration: const Duration(milliseconds: 700),
                child: _childNotifier.value,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                      opacity: animation,
                      child: child
                  );
                },
              );
            },
          ),
        ],
      ),
        bottomNavigationBar: AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
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
                context.go ('/setting');
              }
            },
          ) : SizedBox()
        ),
    );
  }
}
