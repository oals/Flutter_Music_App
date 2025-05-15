import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/utils/comn_utils.dart';
import 'package:skrrskrr/utils/share_utils.dart';

class ShareBtn extends StatelessWidget {
  const ShareBtn({
    super.key,
    required this.imagePath,
    required this.title,
    required this.info,
  });

  final String imagePath;
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() async {

        AppBottomModalRouter.fnModalRouter(
            context,
            9,
            callBack: (String selectShareNm) async {
            if (selectShareNm == "KakaoTalk") {
              String imageUrl = Provider.of<ImageProv>(context,listen: false).imageLoader(imagePath);

              await ShareUtils.shareToKakaoTalk(
                  title,
                  info,
                  imageUrl
              );

            } else if (selectShareNm == "Twitter") {

              String imageUrl = Provider.of<ImageProv>(context,listen: false).imageLoader(imagePath);

              await ShareUtils.shareToTwitter(
                  title,
                  info,
                  imageUrl
              );

            } else if (selectShareNm == "More"){
              SharePlus.instance.share(
                  ShareParams(
                    title: "공유된 콘텐츠",
                    uri: Uri.parse("https://ef8f-116-32-95-167.ngrok-free.app/redirect"),  // 딥링크 URL을 직접 설정
                  ),
              );
            }
         });

      },
      child:Icon(Icons.share_rounded,color: Colors.white,size: 25,)
    );
  }
}
