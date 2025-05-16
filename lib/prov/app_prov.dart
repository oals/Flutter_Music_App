
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/fcm/fcm_notifications.dart';
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';
import 'package:skrrskrr/prov/play_list.prov.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/router/app_screen.dart';
import 'package:skrrskrr/screen/appScreen/login/login_screen.dart';
import 'package:skrrskrr/screen/appScreen/splash/splash_screen.dart';
import 'package:skrrskrr/screen/appScreen/setting/setting_screen.dart';
import 'package:skrrskrr/screen/appScreen/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/utils/comn_utils.dart';
import 'package:uni_links/uni_links.dart';

class AppProv extends ChangeNotifier{

  final TrackProv trackProv;
  final PlayListProv playListProv;
  final MemberProv memberProv;
  final NotificationsProv notificationsProv;

  AppProv(this.trackProv, this.playListProv, this.memberProv, this.notificationsProv);

  int currentIndex = 0;
  Widget appScreenWidget = Container();
  bool isFullScreen = false;

  void notify() {
    notifyListeners();
  }

  Future<bool> firstLoad(String memberEmail) async {

    final String? deviceToken = await FcmNotifications.getMyDeviceToken();
    final url = '/api/firstLoad?memberEmail=${memberEmail}&deviceToken=${deviceToken}';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        memberProv.model = MemberModel.fromJson(ComnUtils.extractValue(response.body, 'member'));
        await memberProv.saveMemberData();

        trackProv.initTrackToModel(["LastListenTrackList",]);
        trackProv.addTracksToModel(ComnUtils.extractValue(response.body, "lastListenTrackList"), "LastListenTrackList");
        trackProv.lastListenTrackList = trackProv.trackListFilter("LastListenTrackList");

        trackProv.initTrackToModel(["RecommendTrackList",]);
        trackProv.addTracksToModel(ComnUtils.extractValue(response.body, "recommendTrackList"), "RecommendTrackList");
        trackProv.recommendTrackList = trackProv.trackListFilter("RecommendTrackList");

        for (var item in ComnUtils.extractValue(response.body, "recommendPlayLists")) {
          playListProv.recommendPlayListsList.playList.add(PlayListInfoModel.fromJson(item));
        }

        for (var item in ComnUtils.extractValue(response.body, "recommendAlbums")) {
          playListProv.recommendAlbumList.playList.add(PlayListInfoModel.fromJson(item));
        }

        for (var item in ComnUtils.extractValue(response.body, "recommendMembers")){
          memberProv.recommendMemberList.add(FollowInfoModel.fromJson(item));
        }

        bool notificationIsView = ComnUtils.extractValue(response.body, 'notificationIsView');
        await prefs.setBool('notificationsIsView', notificationIsView);
        notificationsProv.setNotificationsIsView(notificationIsView);

        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> getCategoryList() async {

    final url = '/api/getCategoryList';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
      );

      if (response.statusCode == 200) {

        ComnUtils.categoryList = List<String>.from(ComnUtils.extractValue(response.body, 'categoryNmList'));

        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
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