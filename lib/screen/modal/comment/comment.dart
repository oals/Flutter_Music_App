
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/comment/comment_model.dart';
import 'package:skrrskrr/prov/comment_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';
import 'package:skrrskrr/screen/subScreen/comment/comment_item.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.trackId,
    required this.notificationCommentId,
    required this.callBack,
  });

  final int? trackId;
  final int? notificationCommentId;
  final Function callBack;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late CommentProv commentProv;
  final TextEditingController textController = TextEditingController();
  String? selectCommentMemberNickName = "";
  int? commentId = null;
  late Future<bool> _getCommentInitFuture;
  late List<CommentModel> commentModel;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _getCommentInitFuture = Provider.of<CommentProv>(context, listen: false).getComment(widget.trackId);
    scrollController = ScrollController();

    if (widget.notificationCommentId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          int index = commentProv.findCommentIndex(commentModel, widget.notificationCommentId!);
          scrollController.jumpTo(index * 8.h);
        });
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    commentProv = Provider.of<CommentProv>(context);

    return Container(
      height: 90.h,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              width: 50,
              height: 8,
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 90.w,
              height: 75.h,
              child: FutureBuilder<bool>(
                future: _getCommentInitFuture, // 비동기 함수 호출
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CustomProgressIndicatorItem());
                  } else {

                    commentModel = commentProv.commentModel;

                    return SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      child: Container(
                        child: Column(
                          children: [
                            for (CommentModel comment in commentModel) ...[
                              CommentItem(
                                  commentModel: comment,
                                  commentLikeCallBack: () {
                                    commentProv.setCommentLike(comment.commentId);
                                    commentProv.fnUpdateCommentLike(comment);
                                  },
                                  replyCommentCallBack: (){
                                    selectCommentMemberNickName = '@${comment.memberNickName} ';
                                    commentId = comment.commentId;
                                    textController.text = '@${comment.memberNickName} ';
                                    textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
                                  },
                                  modalCloseCallBack: (){
                                      widget.callBack();
                                  },
                                  isChildComment: false,
                              ),
                              SizedBox(height: 15),
                              for(CommentModel childComment in comment.childComments ?? []) ...[
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: CommentItem(
                                      commentModel: childComment,
                                      commentLikeCallBack: () {
                                        commentProv.setCommentLike(childComment.commentId);
                                        commentProv.fnUpdateCommentLike(childComment);
                                      },
                                      replyCommentCallBack: (){
                                        selectCommentMemberNickName = '@${childComment.memberNickName} ';
                                        commentId = childComment.commentId;
                                        textController.text = '@${childComment.memberNickName} ';
                                        textController.selection = TextSelection.fromPosition(TextPosition(offset: textController.text.length));
                                      },
                                      modalCloseCallBack: (){
                                        widget.callBack();
                                      },
                                     isChildComment: true,
                                  ),
                                ),
                                SizedBox(height: 15),
                              ]
                            ],

                            if (commentModel.isEmpty) ...[
                              Text(
                                '댓글을 남겨보세요.',
                                style: TextStyle(
                                    color: Colors.grey,
                                ),
                              )
                            ],
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),


            Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.white, // 배경색 설정
                borderRadius: BorderRadius.circular(10), // 둥근 모서리
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        if (!text.contains(selectCommentMemberNickName.toString())) {
                          textController.text = "";
                        }
                      },
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력하세요...',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none, // 테두리 제거
                      ),
                      style: TextStyle(color: Colors.black), // 텍스트 색상
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.black), // 전송 버튼 아이콘
                    onPressed: () async {
                      if (textController.text != "") {

                        await commentProv.setComment(
                            widget.trackId,
                            textController.text,
                            commentId
                        );

                        textController.text = "";
                        selectCommentMemberNickName = "";
                        commentId = null;

                        commentProv.notify();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
