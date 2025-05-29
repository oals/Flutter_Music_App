import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/comment/comment_model.dart';
import 'package:skrrskrr/screen/subScreen/comn/cachedNetworkImage/Custom_Cached_network_image.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({
    super.key,
    required this.commentModel,
    required this.commentLikeCallBack,
    required this.replyCommentCallBack,
    required this.modalCloseCallBack,
    required this.isChildComment,
  });

  final CommentModel commentModel;
  final Function replyCommentCallBack;
  final Function commentLikeCallBack;
  final Function modalCloseCallBack;
  final bool isChildComment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {

  void fnRouter(memberId) {
    widget.modalCloseCallBack();
    GoRouter.of(context).push('/memberPage/${memberId}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("답글 쓰기");
        widget.replyCommentCallBack();
      },
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap : () {
                    fnRouter(widget.commentModel.memberId);
                  },
                  child: ClipOval(
                    child: CustomCachedNetworkImage(
                      imagePath:widget.commentModel.memberImagePath,
                      imageWidth : 8.w,
                      imageHeight : null,
                      isBoxFit: true,
                    ),


                  ),
                ),

                SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      GestureDetector(
                        onTap:() {
                          fnRouter(widget.commentModel.memberId);
                        },
                        child: Text(
                          widget.commentModel.memberNickName!,
                          style: TextStyle(
                              color: Colors.grey),
                        ),
                      ),


                      SizedBox(height: 3),
                      if (widget.isChildComment)
                        Row(
                          children: [
                            Text(
                              widget.commentModel.commentText!.split(' ')[0],
                              style: TextStyle(
                                  color: Colors.grey),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              widget.commentModel.commentText!.split(' ')[1],
                              style: TextStyle(
                                  color: Colors.white),
                            ),
                          ],
                        ),

                      if (!widget.isChildComment)
                        Text(
                          widget.commentModel.commentText!,
                          style: TextStyle(
                              color: Colors.white),
                        ),

                      SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            widget.commentModel.commentDate!,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey),
                          ),

                          SizedBox(width: 5),


                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("댓글 좋아요");
                        widget.commentLikeCallBack();

                      },
                      child: SvgPicture.asset(
                        !widget.commentModel.commentLikeStatus!
                            ? 'assets/images/heart.svg'
                            : 'assets/images/heart_red.svg',
                      ),
                    ),
                    Text(
                      widget.commentModel.commentLikeCnt.toString(),
                      style: TextStyle(
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
