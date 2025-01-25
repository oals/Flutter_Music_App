

import 'package:permission_handler/permission_handler.dart';

class Permissions {


  /** 요청 알림 권한*/
  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isGranted) {
      // 권한이 이미 부여된 경우
      print("알림 권한이 이미 부여되었습니다.");
    } else {
      // 권한이 부여되지 않은 경우 요청
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        print("알림 권한이 부여되었습니다.");
      } else {
        print("알림 권한이 거부되었습니다.");
      }
    }
  }



}