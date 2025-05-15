import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';

import 'package:skrrskrr/utils/comn_utils.dart';

class CustomAppbar extends StatefulWidget {
  const CustomAppbar({
    super.key,
    required this.fnBackBtnCallBack,
    required this.fnUpdateBtnCallBack,
    required this.title,
    required this.isNotification,
    required this.isEditBtn,
    required this.isAddTrackBtn,

  });

  final Function fnBackBtnCallBack;
  final Function fnUpdateBtnCallBack;

  final String title;
  final bool isNotification;
  final bool isEditBtn;
  final bool isAddTrackBtn;


  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {

  late NotificationsProv notificationsProv;
  late Future<void> _getNotificationInitFuture;

  @override
  void initState() {
    super.initState();
    _getNotificationInitFuture = Provider.of<NotificationsProv>(context,listen: false).sharedSaveNotificationsIsView();
  }

  @override
  Widget build(BuildContext context) {

    notificationsProv = Provider.of<NotificationsProv>(context);

    return Container(
      padding: EdgeInsets.only(top: 55,left: 10,right: 10),

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
                  onTap: () => {widget.fnUpdateBtnCallBack()},
                  child: SvgPicture.asset(
                    'assets/images/edit.svg',
                    width: 24,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
              ],


              if (widget.isAddTrackBtn) ...[
                GestureDetector(
                  onTap: () {
                    AppBottomModalRouter.fnModalRouter(context,5,isAlbum: false);
                  },
                  child:SvgPicture.asset(
                    'assets/images/upload.svg',
                    color: Colors.white,
                    width: 28,
                    height: 28,
                  ),
                ),
              ],



              if (widget.isNotification) ...[
                FutureBuilder<void>(
                    future: _getNotificationInitFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CustomProgressIndicatorItem());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('오류 발생: ${snapshot.error}'));
                      } else {
                        return Stack(
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  GoRouter.of(context).push('/notification');
                                },
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                )),
                            if (notificationsProv.notificationsIsView)
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
                        );
                      }
                  }
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
