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
    required this.shareItemId,
    required this.shareId,
    required this.imagePath,
    required this.title,
    required this.info,
  });

  final int shareItemId;
  final int shareId;
  final String imagePath;
  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() async {

        await AppBottomModalRouter().fnModalRouter(
            context,
            9,
            callBack: (String selectShareNm) async {

              Map<String, String> shareMap = {
                "title": title,
                "info": info,
                "imagePath": imagePath,
                "shareId" : shareId.toString(),
                "shareItemId" : shareItemId.toString(),
                "selectShareNm" : selectShareNm,
              };

              await ShareUtils.sendToShareApp(shareMap, context);
         });
      },
      child:Icon(Icons.share_rounded,color: Colors.white,size: 25,)
    );
  }
}
