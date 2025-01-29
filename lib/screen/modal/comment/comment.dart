
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

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    super.key,
    required this.trackId,
  });

  final int? trackId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController textController = TextEditingController();
  String? selectCommentMemberNickName = "";
  int? commentId = null;
  bool? isLoading = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    CommentProv commentProv = Provider.of<CommentProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);

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
                color: Colors.white, //0xff8515e7
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
                future: !isLoading!
                    ? commentProv.getComment(widget.trackId)
                    : null, // 비동기 함수 호출
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // 로딩 상태
                    return Center(child: CircularProgressIndicator());
                  } else {
                    // 데이터가 있을 때
                    List<CommentModel> commentModel = commentProv.commentModel;
        
                    isLoading = true;
        
                    Future<void> fnRouter(memberId)  async{
                      GoRouter.of(context).push('/userPage/${memberId}');
                    }
        
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        child: Column(
                          children: [
                            for (CommentModel comment in commentModel) ...[
                              GestureDetector(
                                onTap: () {
                                  print("답글 쓰기");
                                  // 닉네임을 텍스트 필드에 추가
                                  selectCommentMemberNickName = '@${comment.memberNickName} ';
                                  commentId = comment.commentId;
        
                                  textController.text =
                                  '@${comment.memberNickName} ';
                                  textController.selection =
                                      TextSelection.fromPosition(
                                          TextPosition(
                                              offset: textController
                                                  .text
                                                  .length)); // 커서를 텍스트 끝으로 이동
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
                                              fnRouter(comment.memberId);
                                            },
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: imageProv.imageLoader(comment.memberImagePath),  // 이미지 URL
                                                placeholder: (context, url) {
        
                                                  return CircularProgressIndicator();  // 로딩 중에 표시할 위젯
                                                },
                                                errorWidget: (context, url, error) {
                                                  print('이미지 로딩 실패: $error');
                                                  return Icon(Icons.error);  // 로딩 실패 시 표시할 위젯
                                                },
                                                fadeInDuration: Duration(milliseconds: 500),  // 이미지가 로드될 때 페이드 인 효과
                                                fadeOutDuration: Duration(milliseconds: 500),  // 이미지가 사라질 때 페이드 아웃 효과
                                                width: 8.w,  // 이미지의 가로 크기
                                                fit: BoxFit.cover,  // 이미지가 위젯 크기에 맞게 자르거나 확대하는 방식
                                                imageBuilder: (context, imageProvider) {
        
                                                  return Image(image: imageProvider);  // 이미지가 로드되면 표시
                                                },
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
                                                  onTap:(){
                                                    fnRouter(comment.memberId);
                                                  },
                                                  child: Text(
                                                    comment.memberNickName!,
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ),
        
        
                                                SizedBox(height: 3),
                                                Text(
                                                  comment.commentText!,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    Text(
                                                      comment.commentDate!,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey),
                                                    ),
                                                    SizedBox(width: 5),
                                                    if (comment.childCommentActive!)
                                                      GestureDetector(
                                                        onTap: () {
                                                          AppBottomModalRouter.fnModalRouter(context,4,
                                                              trackId:
                                                                  comment.trackId,
                                                              commentId: comment
                                                                  .commentId);
                                                        },
                                                        child: Text(
                                                          "답글 보기",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            // 밑줄 추가
                                                            decorationColor:
                                                                Colors.grey,
                                                          ),
                                                        ),
                                                      ),
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
        
                                                  commentProv.setCommentLike(comment.commentId);
                                                  setState(() {
                                                    comment.commentLikeStatus = !comment.commentLikeStatus!;
                                                    if(comment.commentLikeStatus!){
                                                      comment.commentLikeCnt = comment.commentLikeCnt! + 1;
                                                    }else {
                                                      comment.commentLikeCnt = comment.commentLikeCnt! - 1;
                                                    }
                                                  });
        
                                                },
                                                child: SvgPicture.asset(
                                                  !comment.commentLikeStatus!
                                                      ? 'assets/images/heart.svg'
                                                      : 'assets/images/heart_red.svg',
                                                  color: Color(0xffff0000),
                                                ),
                                              ),
                                              Text(
                                                comment.commentLikeCnt.toString(),
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
                              ),
                              SizedBox(height: 15),
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
              // 적당한 패딩 추가
              decoration: BoxDecoration(
                color: Colors.white, // 배경색 설정
                borderRadius: BorderRadius.circular(10), // 둥근 모서리
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (text) {
                        if (!text
                            .contains(selectCommentMemberNickName.toString())) {
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
                      // 댓글 전송 로직 추가
                      print('댓글 작성2');
                      if (textController.text != "") {
                        if (selectCommentMemberNickName != "" && textController.text.contains(selectCommentMemberNickName.toString())) {
                          textController.text = textController.text.split(selectCommentMemberNickName.toString())[1];
                          selectCommentMemberNickName = "";
        
                          await commentProv.setComment(
                            widget.trackId,
                            textController.text,
                            commentId,
                          );
                        } else {
                          await commentProv.setComment(
                              widget.trackId, textController.text, null);
                        }
                        commentId = null;
                        textController.text = "";
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
