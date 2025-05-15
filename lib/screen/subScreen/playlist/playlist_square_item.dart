import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';


class PlaylistSquareItem extends StatefulWidget {
  const PlaylistSquareItem({
    super.key,
    required this.playList,
    required this.isHome,
    required this.isAlbum,
  });

  final List<PlayListInfoModel> playList;
  final bool isHome;
  final bool isAlbum;

  @override
  State<PlaylistSquareItem> createState() => _PlaylistSquareItemState();
}

class _PlaylistSquareItemState extends State<PlaylistSquareItem> {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Wrap(
        spacing: 8.0, // 아이템 간의 가로 간격
        runSpacing: 20.0, // 줄 간격
        alignment: WrapAlignment.spaceBetween,
        children: widget.playList.map((item) {

          return Container(
            width: 45.w,
            child: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/playList',extra: item);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomCachedNetworkImage(
                        imagePath: item.playListImagePath,
                        imageWidth: 45.w,
                        imageHeight: null,
                        isBoxFit: false,
                      ),
                    ),
                  ),
                  SizedBox(height: 12,),
                  Text(
                    item.playListNm!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (!widget.isHome)
                    Text(
                      item.memberNickName ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (widget.isHome)
                    Text(
                      widget.isAlbum ? "Trending album" : "Trending playlist",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
