import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/notifications/notifications_model.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';

import 'package:skrrskrr/screen/subScreen/notification/notification_item_screen.dart';
import 'package:skrrskrr/utils/helpers.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotificationInitFuture = Provider.of<NotificationsProv>(context,listen: false).getNotifications(0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    NotificationsProv notificationsProv = Provider.of<NotificationsProv>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.black,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),

              Container(
                width: 100.w,
                height: 75.h,
                child: SingleChildScrollView(
                  child: FutureBuilder<bool>(
                    future: _getNotificationInitFuture,

                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {

                        NotificationsModel notificationsModel = notificationsProv.model;

                        void setNotificationIsView(NotificationsModel notificationItem) async {

                          if(!notificationItem.notificationIsView!){
                            await notificationsProv.setNotificationIsView(notificationItem.notificationId!);

                            setState(() {
                              notificationItem.notificationIsView = true;
                            });
                          }


                          if(notificationItem.notificationType == 1){
                            GoRouter.of(context).push('/trackInfo/${notificationItem.notificationTrackId}');
                          } else if (notificationItem.notificationType == 2){
                            GoRouter.of(context).push('/trackInfo/${notificationItem.notificationTrackId}');
                          } else if (notificationItem.notificationType == 3){
                            GoRouter.of(context).push('/memberPage/${notificationItem.notificationMemberId}');
                          }

                        }


                        // 리스트에서 하나라도 notificationIsView가 true인 것이 있는지 체크하는 함수
                        bool checkNotificationIsViewExistence(List notificationsList) {
                          for (var notification in notificationsList) {
                            if (notification.notificationIsView != null && !notification.notificationIsView!) {
                              return true;
                            }
                          }
                          return false;
                        }

                        // 전체 알림이 비어있는지 체크하는 함수
                        bool checkNotificationExistence(List todayList, List monthList, List yearList) {
                          return todayList.isNotEmpty || monthList.isNotEmpty || yearList.isNotEmpty;
                        }

                        // today, month, year 알림에서 "isView" 상태가 true인 것이 있는지 체크
                        notificationIsViewExistence = checkNotificationIsViewExistence(notificationsModel.todayNotificationsList) ||
                            checkNotificationIsViewExistence(notificationsModel.monthNotificationsList) ||
                            checkNotificationIsViewExistence(notificationsModel.yearNotificationsList);

                        // 알림 리스트 중 하나라도 비어 있지 않은지 체크
                        notificationIsExistence = checkNotificationExistence(notificationsModel.todayNotificationsList,
                            notificationsModel.monthNotificationsList,
                            notificationsModel.yearNotificationsList);


                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                  ),
                                ),

                                Row(
                                  children: [

                                    GestureDetector(
                                      onTap: ()=>{
                                        if(notificationIsViewExistence){
                                          notificationsProv.setAllNotificationIsView(),

                                          for(int i = 0; i < notificationsModel.todayNotificationsList.length; i++){
                                            notificationsModel.todayNotificationsList[i]
                                                .notificationIsView = true
                                          },
                                          for(int i = 0; i < notificationsModel.monthNotificationsList.length; i++){
                                            notificationsModel.monthNotificationsList[i]
                                                .notificationIsView = true
                                          },
                                          for(int i = 0; i < notificationsModel.yearNotificationsList.length; i++){
                                            notificationsModel.yearNotificationsList[i]
                                                .notificationIsView = true
                                          },

                                          Fluttertoast.showToast(msg: '전체 읽음 처리 되었습니다..'),

                                          notificationIsViewExistence = false,

                                          setState(() {},
                                          ),

                                        },
                                      },
                                      child: Container(
                                        color: Color(0xFF1C1C1C),
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '전체 읽음',
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
                                        print('전체삭제'),
                                        if(notificationIsExistence){

                                          notificationsProv.setDelNotificationIsView(),

                                          notificationsModel.todayNotificationsList = [],
                                          notificationsModel.monthNotificationsList = [],
                                          notificationsModel.yearNotificationsList = [],
                                          notificationIsExistence = false,
                                          notificationIsViewExistence = false,
                                          setState(() {
                                          })

                                        }
                                      },
                                      child: Container(
                                        color: Color(0xFF1C1C1C),
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          '전체 삭제',
                                          style: TextStyle(
                                              color: notificationIsExistence ? Colors.white : Colors.grey,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),


                              ],
                            ),


                            if(notificationIsExistence)...[
                              if(notificationsModel.todayNotificationsList.length != 0)...[
                                SizedBox(height: 10),
                                Text(
                                  '오늘',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                              ],

                              for(int i = 0; i < notificationsModel.todayNotificationsList.length; i++)...[
                                  GestureDetector(
                                    onTap : () {
                                        setNotificationIsView(notificationsModel.todayNotificationsList[i]);
                                      },
                                    child: NotificationItemScreen(notificationsModel : notificationsModel.todayNotificationsList[i]))
                              ],

                              if(notificationsModel.monthNotificationsList.length != 0)...[
                                SizedBox(height: 10),
                                Text(
                                  '이번 달',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                              ],

                              for(int i = 0; i < notificationsModel.monthNotificationsList.length; i++)...[
                                  GestureDetector(
                                      onTap : () {
                                          setNotificationIsView(notificationsModel.monthNotificationsList[i]);
                                        },
                                      child: NotificationItemScreen(notificationsModel : notificationsModel.monthNotificationsList[i]))
                              ],

                              if(notificationsModel.yearNotificationsList.length != 0)...[
                                SizedBox(height: 10),
                                Text(
                                  '그 외',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                              ],

                              for(int i = 0; i < notificationsModel.yearNotificationsList.length; i++)...[
                                  GestureDetector(
                                      onTap : () {
                                          setNotificationIsView(notificationsModel.yearNotificationsList[i]);
                                        },
                                      child: NotificationItemScreen(notificationsModel : notificationsModel.yearNotificationsList[i]))
                              ],
                            ],

                            if(!notificationIsExistence)...[
                              Container(
                                width : 100.w,
                                padding: EdgeInsets.only(top: 33.h),
                                child: Text(
                                  'Empty',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]


                          ],
                        );

                      }


                    },
                  ),
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}
