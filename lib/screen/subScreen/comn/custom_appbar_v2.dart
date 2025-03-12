import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/prov/member_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';

class CustomAppbarV2 extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbarV2({
    super.key,
    required this.isNotification,
    this.preferredSize = const Size.fromHeight(100), // 기본 높이를 지정
  });

  final bool isNotification;
  @override
  final Size preferredSize; // 앱바의 높이를 설정하는 preferredSize

  @override
  State<CustomAppbarV2> createState() => _CustomAppbarV2State();
}

class _CustomAppbarV2State extends State<CustomAppbarV2> {
  late bool notificationisView = false;
  bool isLoading = false;
  late String? memberNickName;
  late String? memberImagePath;


  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // 비동기적으로 SharedPreferences를 로드하는 함수
  Future<void> _loadPreferences() async {
    notificationisView = await Helpers.getNotificationIsView();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    memberNickName = prefs.getString("memberNickName");
    memberImagePath = prefs.getString("memberImagePath");
    isLoading = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if(!isLoading){
      return CircularProgressIndicator();
    }

    ImageProv imageProv = Provider.of<ImageProv>(context);

    return Container(
      color: Color(0xff000000),
      height: widget.preferredSize.height, // 생성자에서 설정한 높이를 사용
      child: Container(
        padding: EdgeInsets.only(top: 40,left: 10,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: imageProv.imageLoader(memberImagePath),
                  placeholder: (context, url) {
                    return SizedBox(); // 로딩 중에 표시할 위젯
                  },
                  errorWidget: (context, url, error) {
                    return Icon(Icons.error); // 로딩 실패 시 표시할 위젯
                  },
                  fadeInDuration: Duration(milliseconds: 1000),
                  fadeOutDuration: Duration(milliseconds: 1000),
                  width: 9.w,
                  height: 4.5.h,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) {
                    return ClipOval(child: Image(image: imageProvider)); // 이미지가 로드되면 표시
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  memberNickName ?? "null",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (widget.isNotification) ...[
              Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      GoRouter.of(context).push('/notification');
                    },
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  ),
                  if (notificationisView)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
