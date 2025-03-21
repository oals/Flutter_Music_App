
import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/router/app_screen.dart';
import 'package:skrrskrr/screen/appScreen/comn/login.dart';
import 'package:skrrskrr/screen/appScreen/comn/splash.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting.dart';
import 'package:skrrskrr/screen/appScreen/home/home.dart';

class AppProv extends ChangeNotifier{

  ValueNotifier<bool> hlsNotifier = ValueNotifier<bool>(false);
  int currentIndex = 0;
  int testValue = 0;


  Widget testWidget = Container();

  bool isFullScreen = false;
  OverlayEntry? _overlayEntry = null;
  final ValueNotifier<Widget> _childNotifier = ValueNotifier<Widget>(Container());


  void notify() {
    notifyListeners();
  }

  void reload() {
    hlsNotifier.value = !hlsNotifier.value;
  }

  void isFullScreenFunc(bool isFullScreenVal) {
    isFullScreen = isFullScreenVal;
    notify();
  }

  bool isHideAudioPlayer(Widget widget) {
    return (widget is SplashScreen || widget is LoginScreen);
  }

  bool isShowBottomNav(Widget widget) {
    return !(widget is SplashScreen || widget is LoginScreen);
  }

  bool isShowAppbar(Widget widget) {
    return isFullScreen || !(widget is HomeScreen || widget is SettingScreen);
  }


}