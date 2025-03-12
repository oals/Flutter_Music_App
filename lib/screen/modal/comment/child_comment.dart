import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/comment/comment_model.dart';
import 'package:skrrskrr/prov/comment_prov.dart';
import 'package:skrrskrr/prov/image_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/Custom_Cached_network_image.dart';

class ChildCommentScreen extends StatefulWidget {
  const ChildCommentScreen({
    super.key,
    required this.commentId,
    required this.trackId,
  });

  final int? commentId;
  final int? trackId;

  @override
  State<ChildCommentScreen> createState() => _ChildCommentScreenState();
}

class _ChildCommentScreenState extends State<ChildCommentScreen> {
  final TextEditingController textController = TextEditingController();
  late String? selectCommentMemberNickName;
  late int? selectCommentId;
  late Future<bool> _getChildCommentInitFuture;
  late CommentProv commentProv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getChildCommentInitFuture = Provider.of<CommentProv>(context,listen: false).getChildComment(widget.commentId);

  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    commentProv = Provider.of<CommentProv>(context);
    ImageProv imageProv = Provider.of<ImageProv>(context);

    return Container(
      height: 90.h,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
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
              future: _getChildCommentInitFuture, // 비동기 함수 호출
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 로딩 상태
                  return Center(child: CircularProgressIndicator());
                } else {
                  // 데이터가 있을 때
                  CommentModel childCommentModel = commentProv.childCommentModel;


                  Future<void> fnRouter(memberId)  async{
                    GoRouter.of(context).push('/userPage/${memberId}');
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    selectCommentId = childCommentModel.commentId;
                    selectCommentMemberNickName = '@${childCommentModel.memberNickName} ';
                    textController.text = '@${childCommentModel.memberNickName} ';
                    // textController.selection =
                    //     TextSelection.fromPosition(
                    //         TextPosition(
                    //             offset: textController
                    //                 .text
                    //                 .length));
                  });



                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      child: Column(
                        children: [

                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    GestureDetector(
                                      onTap : () {
                                        fnRouter(childCommentModel.memberId);
                                      },
                                      child: ClipOval(
                                        child: CustomCachedNetworkImage(
                                            imagePath: childCommentModel.memberImagePath,
                                            imageWidth : 8.w,
                                            imageHeight : null
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
                                              fnRouter(childCommentModel.memberId);
                                            },
                                            child: Text(
                                              childCommentModel.memberNickName!,
                                              style: TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            childCommentModel.commentText!,
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Text(
                                                childCommentModel.commentDate!,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(width: 5),
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     print("답글 쓰기123");
                                              //     // 닉네임을 텍스트 필드에 추가
                                              //     selectCommentId = childCommentModel.commentId;
                                              //     selectCommentMemberNickName = '@${childCommentModel.memberNickName} ';
                                              //     textController.text = '@${childCommentModel.memberNickName} ';
                                              //     textController.selection =
                                              //         TextSelection.fromPosition(
                                              //             TextPosition(
                                              //                 offset: textController
                                              //                     .text
                                              //                     .length)); // 커서를 텍스트 끝으로 이동
                                              //   },
                                              //   child: Text(
                                              //     "답글 쓰기",
                                              //     style: TextStyle(
                                              //       fontSize: 13,
                                              //       color: Colors.grey,
                                              //       decoration: TextDecoration
                                              //           .underline, // 밑줄 추가
                                              //       decorationColor:
                                              //       Colors.grey,
                                              //     ),
                                              //   ),
                                              // ),
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
                                            print("댓글 좋아요2");

                                            commentProv.setCommentLike(
                                                childCommentModel.commentId);

                                            setState(() {

                                              childCommentModel.commentLikeStatus = !childCommentModel.commentLikeStatus!;
                                              if(childCommentModel.commentLikeStatus!){
                                                childCommentModel.commentLikeCnt = childCommentModel.commentLikeCnt! + 1;
                                              }else {
                                                childCommentModel.commentLikeCnt = childCommentModel.commentLikeCnt! - 1;
                                              }

                                            });

                                            ///화면 구조 나누고 나서 setstate로
                                          },
                                          child: SvgPicture.asset(
                                            !childCommentModel
                                                .commentLikeStatus!
                                                ? 'assets/images/heart.svg'
                                                : 'assets/images/heart_red.svg',
                                            color: Color(0xffff0000),
                                          ),
                                        ),
                                        Text(
                                          childCommentModel.commentLikeCnt.toString(),
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

                          SizedBox(height: 10,),
                          Container(
                            width: 100.w,
                            height: 0.6,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10,),
                          if(childCommentModel.childComment != null)
                            for (int i = 0; i < childCommentModel.childComment!.length; i++) ...[
                              Container(
                                width: 90.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 7.w,),
                                        GestureDetector(
                                          onTap : () {
                                            fnRouter(childCommentModel.childComment?[i].memberId);
                                          },
                                          child: ClipOval(
                                            child: CustomCachedNetworkImage(
                                                imagePath: childCommentModel.childComment![i].memberImagePath,
                                                imageWidth : 8.w,
                                                imageHeight : null
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
                                                  fnRouter(childCommentModel.childComment?[i].memberId);
                                                },
                                                child: Text(
                                                  childCommentModel.childComment![i].memberNickName!,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap:(){
                                                      fnRouter(childCommentModel.childComment?[i].parentCommentMemberId);
                                                    },
                                                    child: Text(
                                                      childCommentModel.childComment![i].parentCommentMemberNickName!,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Text(
                                                    childCommentModel.childComment![i].commentText!,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Text(
                                                    childCommentModel.childComment![i]
                                                        .commentDate!,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey),
                                                  ),
                                                  SizedBox(width: 5),
                                                  GestureDetector(
                                                    onTap: () {
                                                      print("답글 쓰기");
                                                      selectCommentId = childCommentModel.childComment![i].commentId;
                                                      // 닉네임을 텍스트 필드에 추가
                                                      selectCommentMemberNickName =
                                                          '@${childCommentModel.childComment![i].memberNickName} ';

                                                      textController.text =
                                                          '@${childCommentModel.childComment![i].memberNickName} ';
                                                      textController.selection =
                                                          TextSelection.fromPosition(
                                                              TextPosition(
                                                                  offset: textController
                                                                      .text
                                                                      .length)); // 커서를 텍스트 끝으로 이동
                                                    },
                                                    child: Text(
                                                      "답글 쓰기",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                        decoration: TextDecoration
                                                            .underline, // 밑줄 추가
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

                                                commentProv.setCommentLike(
                                                    childCommentModel.childComment![i].commentId);

                                                setState(() {
                                                  childCommentModel.childComment![i].commentLikeStatus = !childCommentModel.childComment![i].commentLikeStatus!;
                                                  if(childCommentModel.childComment![i].commentLikeStatus!){
                                                    childCommentModel.childComment![i].commentLikeCnt = childCommentModel.childComment![i].commentLikeCnt! + 1;
                                                  }else {
                                                    childCommentModel.childComment![i].commentLikeCnt = childCommentModel.childComment![i].commentLikeCnt! - 1;
                                                  }
                                                });

                                              },
                                              child: SvgPicture.asset(
                                                childCommentModel.childComment![i]
                                                            .commentLikeStatus !=
                                                        true
                                                    ? 'assets/images/heart.svg'
                                                    : 'assets/images/heart_red.svg',
                                                color: Color(0xffff0000),
                                              ),
                                            ),
                                            Text(
                                              childCommentModel.childComment![i].commentLikeCnt.toString(),
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
                            SizedBox(height: 15),
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
                    print('댓글 작성');
                    if (textController.text != "") {
                      if (textController.text.contains(selectCommentMemberNickName.toString())) {
                        textController.text = textController.text
                            .split(selectCommentMemberNickName.toString())[1];
                        selectCommentMemberNickName = "";
                      }
                      print(selectCommentId);
                      await commentProv.setComment(widget.trackId, textController.text,selectCommentId);
                      selectCommentId = widget.commentId;
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
    );
  }
}
