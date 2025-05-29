import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/router/app_router_config.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareUtils {

  static String redirectPath = "https://351f-116-32-95-167.ngrok-free.app/redirect";

  static void deepLinkListener() {
    uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {

        SharedPreferences prefs = await SharedPreferences.getInstance();

        print("✅ 앱 실행 되어 있을 시 감지된 딥 링크: ${uri.toString()}");

        if (FirebaseAuth.instance.currentUser != null) {
           await prefs.setString('deepLink', "");
           handleDeepLink(uri);
        } else {
          await prefs.setString('deepLink', uri.toString());
        }
      }
    });
  }

  static void deepLinkInit() async {
    String? initialLink = await getInitialLink();
    if (initialLink != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Uri initialUri = Uri.parse(initialLink);

      print("✅ 앱 시작 시 감지된 딥 링크: ${initialUri.toString()}");

      await prefs.setString('deepLink', initialUri.toString());
    }
  }

  static void deepLinkMove() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deepLink = prefs.getString("deepLink");

    if (deepLink != null && deepLink.isNotEmpty) {
      Uri uri = Uri.parse(prefs.getString("deepLink")!);
      ShareUtils.handleDeepLink(uri);
      prefs.setString('deepLink',"");
    }
  }

  static void handleDeepLink(Uri uri) {

    if (uri.queryParameters.containsKey('playlistId')) {
      String playlistId = uri.queryParameters['playlistId']!;
      print("플레이리스트 ID: $playlistId");

      PlayListInfoModel playListInfoModel = PlayListInfoModel();
      playListInfoModel.playListId = int.parse(playlistId);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(navigatorKey.currentContext!).push('/playList',extra: playListInfoModel);
      });

    } else if (uri.queryParameters.containsKey('trackId')) {
      String trackId = uri.queryParameters['trackId']!;
      print("트랙 ID: $trackId");

      Track track = Track();
      track.trackId = int.parse(trackId);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(navigatorKey.currentContext!).push('/trackInfo',
          extra: {
            'track': track,
            'commendId': null,
          },
        );
      });

    }
  }

  static Future<void> shareToKakaoTalk(Map<String, String> shareMap) async {

    String imagePath = shareMap['imagePath']!.replaceAll("http://10.0.2.2:8102","https://351f-116-32-95-167.ngrok-free.app");

    final response = await ShareClient.instance.shareCustom(
      templateId: 120629,
      templateArgs: {
        "imagePath" : imagePath,
        "shareId": shareMap['shareId']!,
        'shareItemId' : shareMap['shareItemId']!,
        "title": shareMap['title']! + '\n',
        "info": shareMap['info']! + "\n",
      },
    );

    if (await canLaunchUrl(Uri.parse(response.toString()))) {
      try {
        await launchUrl(Uri.parse(response.toString()), mode: LaunchMode.externalApplication);
      } catch (e) {
        print("카카오톡 실행 오류: $e");
      }
    } else {
      print("카카오톡 실행 실패 ❌");
    }
  }

  static Future<void> shareToTwitter(Map<String,String> shareMap) async {

    final twitterUrl = "https://twitter.com/intent/tweet?text=${Uri.encodeComponent("${shareMap['title']}\n${shareMap['info']}\n\n${redirectPath + "/${shareMap['shareId']}/${shareMap['shareItemId']}"}")}";

    if (await canLaunchUrl(Uri.parse(twitterUrl))) {
      await launchUrl(Uri.parse(twitterUrl), mode: LaunchMode.externalApplication);
    } else {
      print("트위터 실행 실패 ❌");
    }
  }

  static Future<void> shareToLine(Map<String, String> shareMap) async {

    final lineUrl = "line://msg/text/${Uri.encodeComponent("${shareMap['title']}\n${shareMap['info']}\n\n${redirectPath + "/${shareMap['shareId']}/${shareMap['shareItemId']}"} ")}";

    if (await canLaunchUrl(Uri.parse(lineUrl))) {
      await launchUrl(Uri.parse(lineUrl), mode: LaunchMode.externalApplication);
    } else {
      print("LINE 실행 실패 ❌");
    }
  }

  static Future<void> shareToMore(Map<String,String> shareMap) async {

    SharePlus.instance.share(
      ShareParams(
        text: "${shareMap['title']}\n\n"
              "${shareMap['info']}\n\n"
              "[${redirectPath + "/${shareMap['shareId']}/${shareMap['shareItemId']}"}]",
      ),
    );
  }

  static Future<void> openPlayStore(String appId) async {

    await launchUrl(
        Uri.parse("https://play.google.com/store/apps/details?id=${appId}"),
        mode: LaunchMode.externalApplication
    ); // Play Store 이동
  }

  static Future<bool> isShareAppInstalled(String packageName) async {
    return await DeviceApps.isAppInstalled(packageName);
  }

 static Future<void> sendToShareApp(Map<String, String> shareMap, BuildContext context) async {

   if (shareMap['selectShareNm'] == "KakaoTalk") {
     shareMap['imagePath'] = Provider.of<ImageProv>(context,listen: false).imageLoader(shareMap['imagePath']);;
     await ShareUtils.shareToKakaoTalk(shareMap);
   } else if (shareMap['selectShareNm'] == "X") {
     await ShareUtils.shareToTwitter(shareMap);
   } else if (shareMap['selectShareNm'] == "Line") {
     await ShareUtils.shareToLine(shareMap);
   } else {
     ShareUtils.shareToMore(shareMap);
   }
 }

}