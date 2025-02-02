import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';

import 'package:skrrskrr/utils/helpers.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({
    super.key,
    required this.fnBackBtnCallBack,
    required this.fnUpdtBtnCallBack,
    required this.title,
    required this.isNotification,
    required this.isEditBtn,
    required this.isAddPlayListBtn,
    required this.isAddTrackBtn,
    required this.isAddAlbumBtn,
  });

  final Function fnBackBtnCallBack;
  final Function fnUpdtBtnCallBack;

  final String title;
  final bool isNotification;
  final bool isEditBtn;
  final bool isAddPlayListBtn;
  final bool isAddTrackBtn;
  final bool isAddAlbumBtn;

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  late bool notificationisView = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // 비동기적으로 SharedPreferences를 로드하는 함수
  Future<void> _loadPreferences() async {
    notificationisView = await Helpers.getNotificationIsView();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 55,left: 15,right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                widget.fnBackBtnCallBack();
              },
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              )),
          Text(
            widget.title,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Row(
            children: [
              if (widget.isEditBtn) ...[
                GestureDetector(
                  onTap: () => {widget.fnUpdtBtnCallBack()},
                  child: SvgPicture.asset(
                    'assets/images/edit.svg',
                    width: 24,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
              if (widget.isAddPlayListBtn) ...[
                GestureDetector(
                  onTap: () {
                    AppBottomModalRouter.fnModalRouter(context, 2);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
              if (widget.isAddAlbumBtn) ...[
                GestureDetector(
                  onTap: () {
                    AppBottomModalRouter.fnModalRouter(context, 5,isAlbum: widget.isAddAlbumBtn);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],

              if (widget.isAddTrackBtn) ...[
                GestureDetector(
                  onTap: () {
                    AppBottomModalRouter.fnModalRouter(context,1,isAlbum: widget.isAddAlbumBtn);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],



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
                        )),
                    if (notificationisView)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                  ],
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
