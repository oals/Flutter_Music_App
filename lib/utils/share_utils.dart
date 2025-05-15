
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:skrrskrr/utils/comn_utils.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareUtils {

  // 앱이 켜져 있을 때
  static void deepLinkListener() {
    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print("✅ 앱 실행 되어 있을 시 감지된 딥 링크: ${uri.toString()}");
        handleDeepLink(uri);
      }
    });
  }

  // 앱이 꺼져 있을 때
  static Future<void> deepLinkInit() async {
    String? initialLink = await getInitialLink(); // 초기 실행 시 링크 확인
    if (initialLink != null) {
      Uri initialUri = Uri.parse(initialLink);
      print("✅ 앱 시작 시 감지된 딥 링크: ${initialUri.toString()}");
      handleDeepLink(initialUri);
    }
  }

  static void handleDeepLink(Uri uri) {
    if (uri.queryParameters.containsKey('playlistId')) {
      String playlistId = uri.queryParameters['playlistId']!;
      print("플레이리스트 ID: $playlistId");
    }
  }

  static Future<void> shareToKakaoTalk(String title, String info,String imageUrl) async {

    String deepLink = "https://ef8f-116-32-95-167.ngrok-free.app/redirect";

    final response = await ShareClient.instance.shareDefault(
      template: FeedTemplate(
        buttons: [
          Button(
            title: "앱에서 열기 🎵",
            link: Link(
              webUrl: Uri.parse(deepLink),
              mobileWebUrl: Uri.parse(deepLink),
            ),
          ),
        ],
        content: Content(
            title: title,
            description: "이 링크를 클릭하면 바로 앱에서 열려요!\n${deepLink}",
            imageWidth: 400,
            imageHeight: 300,
            imageUrl: Uri.parse(imageUrl),

            link: Link(
              webUrl: Uri.parse(deepLink),
              mobileWebUrl: Uri.parse(deepLink),
            )
        ),
      ),
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

  static Future<void> shareToTwitter(String title,String info, String url) async {

    final twitterUrl = "https://twitter.com/intent/tweet?text=${Uri.encodeComponent("$title\n$info")}&url=$url";

    if (await canLaunchUrl(Uri.parse(twitterUrl))) {
      await launchUrl(Uri.parse(twitterUrl), mode: LaunchMode.externalApplication);
    } else {
      print("트위터 실행 실패 ❌");
    }
  }

  static Future<void> shareToInstagram(String imagePath) async {
    final instagramUrl = "instagram://story-camera";

    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl), mode: LaunchMode.externalApplication);
    } else {
      print("인스타그램 실행 실패 ❌");
    }
  }


}