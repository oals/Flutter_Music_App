import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/notifications/notifications_model.dart';
import 'package:skrrskrr/prov/notifications_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';

class NotificationItemScreen extends StatefulWidget {
  const NotificationItemScreen({
    super.key,
    required this.notificationsModel,
  });

  final NotificationsModel notificationsModel;

  @override
  State<NotificationItemScreen> createState() => _NotificationItemScreenState();
}

class _NotificationItemScreenState extends State<NotificationItemScreen> {
  @override
  Widget build(BuildContext context) {

    return Container(
      width: 100.w,
      height: 7.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              ClipOval(
                child: CustomCachedNetworkImage(
                  imagePath: widget.notificationsModel.memberImagePath,
                  imageWidth: 10.w,
                  imageHeight: 5.h,
                  isBoxFit: false,
                ),
              ),


              SizedBox(
                width: 10,
              ),
              Container(
                width: 67.w,
                child: Text(
                  widget.notificationsModel.notificationMsg!,
                    style: TextStyle(
                      color: !widget.notificationsModel.notificationIsView! ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis
                    ),

                ),
              ),
            ],
          ),
          Text(
            widget.notificationsModel.notificationDate!.substring(2,widget.notificationsModel.notificationDate!.length),
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                overflow: TextOverflow.ellipsis
            ),

          ),

        ],
      ),
    );
  }
}
