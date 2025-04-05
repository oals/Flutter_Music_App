
import 'package:flutter/cupertino.dart';
import 'package:skrrskrr/router/app_screen.dart';
import 'package:skrrskrr/screen/appScreen/login/login_screen.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting_screen.dart';
import 'package:skrrskrr/screen/appScreen/home/home_screen.dart';

class AppProv extends ChangeNotifier{

  ValueNotifier<bool> hlsNotifier = ValueNotifier<bool>(false);
  int currentIndex = 0;
  Widget appScreenWidget = Container();
  bool isFullScreen = false;
  bool isPlayTrack = false;

  void notify() {
    notifyListeners();
  }

  void reload() {
    print('리로드');
    hlsNotifier.value = !hlsNotifier.value;
    isPlayTrack = true;
  }

  void isFullScreenFunc(bool isFullScreenVal) {
    isFullScreen = isFullScreenVal;
    notify();
  }

  bool isHideAudioPlayer(Widget widget) {
    return  (widget is SplashScreen || widget is LoginScreen);
  }

  bool isShowBottomNav(Widget widget) {
    return !isFullScreen && !(widget is SplashScreen || widget is LoginScreen);
  }

  bool isShowAppbar(Widget widget) {
    return !(widget is HomeScreen || widget is SettingScreen);
  }


}