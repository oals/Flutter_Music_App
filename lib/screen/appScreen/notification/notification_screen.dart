import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/notifications/notifications_model.dart';
import 'package:skrrskrr/prov/comn_load_prov.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_indicator.dart';
import 'package:skrrskrr/screen/subScreen/notification/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  late Future<bool> _getNotificationInitFuture;
  late bool notificationIsViewExistence = false;
  late bool notificationIsExistence = false;
  late ComnLoadProv comnLoadProv;
  late NotificationsProv notificationsProv;

  @override
  void initState() {
    super.initState();
    _getNotificationInitFuture = Provider.of<NotificationsProv>(context,listen: false).getNotifications(0);
  }

  @override
  Widget build(BuildContext context) {

    notificationsProv = Provider.of<NotificationsProv>(context);
    comnLoadProv = Provider.of<ComnLoadProv>(context);

    return Scaffold(
      body: Container(

        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomAppbar(
              fnBackBtnCallBack: () => {GoRouter.of(context).pop()},
              fnUpdateBtnCallBack: () => {},
              title: "Notifications",
              isNotification: false,
              isEditBtn: false,
              isAddTrackBtn : false,
            ),

            Container(
              width: 100.w,
              height: 85.h,
              padding: EdgeInsets.only(left: 8,right: 8),
              child: FutureBuilder<bool>(
                future: _getNotificationInitFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {

                    NotificationsModel notificationsModel = notificationsProv.model;

                    // 알림에서 "isView" 상태가 true인 것이 있는지 체크
                    notificationIsViewExistence = notificationsProv.checkNotificationIsViewExistence(notificationsModel.notificationList);

                    // 알림 리스트 중 하나라도 비어 있지 않은지 체크
                    notificationIsExistence = notificationsProv.checkNotificationExistence(notificationsModel.notificationList);

                    return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                        if (notificationsModel.totalCount! >  notificationsModel.notificationList.length) {
                          if (comnLoadProv.shouldLoadMoreData(notification)) {
                            comnLoadProv.loadMoreData(notificationsProv, "Notifications",  notificationsModel.notificationList.length );
                          }
                        } else {
                          if (comnLoadProv.isApiCall) {
                            comnLoadProv.resetApiCallStatus();
                          }
                        }
                        return false;
                      },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              GestureDetector(
                                onTap: ()=>{
                                  if (notificationIsViewExistence) {
                                    notificationsProv.setAllNotificationIsView(),

                                    for (int i = 0; i < notificationsModel.notificationList.length; i++) {
                                      notificationsModel.notificationList[i].notificationIsView = true
                                    },

                                    Fluttertoast.showToast(msg: '전체 읽음 처리 되었습니다..'),
                                    notificationIsViewExistence = false,
                                    setState(() {}),
                                  },
                                },
                                child: Container(
                                  color: Color(0xFF1C1C1C),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Mark all as read',
                                    style: TextStyle(
                                        color: notificationIsViewExistence ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12),
                                  ),
                                ),
                              ),

                              SizedBox(width: 5,),

                              GestureDetector(
                                onTap: ()=>{

                                  if (notificationIsExistence) {
                                    notificationsProv.setDelNotificationIsView(),
                                    notificationsModel.notificationList = [],
                                    notificationIsExistence = false,
                                    notificationIsViewExistence = false,
                                    setState(() {})
                                  }
                                },
                                child: Container(
                                  color: Color(0xFF1C1C1C),
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    'Delete all ',
                                    style: TextStyle(
                                        color: notificationIsExistence ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (notificationIsExistence)...[
                            for (int i = 0; i < notificationsModel.notificationList.length; i++)
                              GestureDetector(
                                  onTap : () {
                                     notificationsProv.moveNotification(notificationsModel.notificationList[i],context);
                                    },
                                  child: NotificationItem(notificationsModel : notificationsModel.notificationList[i]),
                              ),
                          ],

                          if (!notificationIsExistence)...[
                            Container(
                              width : 100.w,
                              padding: EdgeInsets.only(top: 33.h),
                              child: Text(
                                'Empty',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],

                          Center(
                              child: CustomProgressIndicator(isApiCall: comnLoadProv.isApiCall)
                          ),

                        ],
                      ),
                     ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
