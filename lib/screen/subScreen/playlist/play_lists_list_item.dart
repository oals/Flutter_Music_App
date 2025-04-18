import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';

class PlayListsListItem extends StatefulWidget {
  const PlayListsListItem({
    super.key,
    required this.playList,
    required this.isAlbum,
  });

  final PlayListInfoModel playList;
  final bool isAlbum;

  @override
  State<PlayListsListItem> createState() => _PlayListsListItemState();
}

class _PlayListsListItemState extends State<PlayListsListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        GoRouter.of(context).push('/playList',extra: widget.playList);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  children: [

                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey,width: 1),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5), // 원하는 둥글기 조정
                            child: CustomCachedNetworkImage(
                              imagePath: widget.playList.playListImagePath,
                              imageWidth : 15.w,
                              imageHeight : null,
                              isBoxFit: true,
                            ),

                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            width: 57.w,
                            child: Text(
                              '${widget.playList.playListNm}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 2,),
                          Row(
                            children: [
                              Row(
                                children: [
                                  if(widget.playList.isPlayListPrivacy!)
                                    Row(
                                      children: [
                                        Icon(Icons.lock,color: Colors.white,size: 12,),
                                        SizedBox(width: 1.5,),
                                        Text('Private',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,

                                          ),
                                        ),
                                      ],
                                    ),
                                  if(!widget.playList.isPlayListPrivacy!)
                                    Text(
                                      widget.isAlbum ?  'Album' : 'Playlist',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,

                                      ),
                                    ),

                                  SizedBox(width: 5,),

                                  Text(
                                    '${widget.playList.trackCnt} tracks',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5,),
                            ],
                          ),
                          SizedBox(height: 1,),
                          Row(
                            children: [
                              Text(
                                '${widget.playList.totalPlayTime}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 5,),
                              SvgPicture.asset(
                                widget.playList.isPlayListLike! ? 'assets/images/heart_red.svg' : 'assets/images/heart.svg',
                                width: 15,
                                height: 15,
                              ),
                              SizedBox(width: 1,),
                              Text(
                                '${widget.playList.playListLikeCnt}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),


                            ],
                          ),

                          SizedBox(height: 5,),
                          Row(
                            children: [
                              ClipOval(
                                child: CustomCachedNetworkImage(
                                  imagePath: widget.playList.memberImagePath,
                                  imageWidth: 4.5.w,
                                  imageHeight: null,
                                  isBoxFit: true,
                                ),
                              ),
                              SizedBox(width: 5,),
                              GestureDetector(
                                onTap: (){
                                  GoRouter.of(context).push('/userPage/${widget.playList.memberId}');
                                },
                                child: Text(
                                  '${widget.playList.memberNickName}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.09,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
