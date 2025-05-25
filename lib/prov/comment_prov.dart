import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/comment/comment_model.dart';
import 'package:skrrskrr/utils/comn_utils.dart';

class CommentProv extends ChangeNotifier {

  List<CommentModel> commentModel = [];

  void clear() {
    commentModel = [];
  }

  void notify() {
    notifyListeners();
  }

  Future<bool> setCommentLike(commentId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/setCommentLike';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        method: "POST",
        headers: {
          'Content-Type': 'application/json'
        },
        body:{
          'loginMemberId': loginMemberId,
          'commentId': commentId,
        }, 
      );

      if (response.statusCode == 200) {
        print('$url - Successful');
        return true;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> setComment(trackId, String commentText, int? commentId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/setComment';

    try {
      http.Response response = await ComnUtils.apiCall(
        url,
        method: "POST",
        headers: {
          'Content-Type': 'application/json'
        },
        body: {
          'loginMemberId': loginMemberId,
          'trackId': trackId.toString(),
          'commentText': commentText,
          'commentId': commentId,
        },
      );

      if (response.statusCode == 200) {

        CommentModel newComment = CommentModel.fromJson(ComnUtils.extractValue(response.body, 'comment'));

        if (commentId == null) {
          commentModel.insert(0, newComment);
        } else {
          addCommentToModel(commentModel,commentId, newComment);
        }

        print('$url - Successful');
        return true;;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> getComment(trackId) async {

    final String loginMemberId = await ComnUtils.getMemberId();
    final url = '/api/getComment?trackId=${trackId}&loginMemberId=${loginMemberId}';

    try {
      http.Response response = await ComnUtils.apiCall(
          url
      );

      if (response.statusCode == 200) {

        commentModel = [];

        for (var comment in ComnUtils.extractValue(response.body, 'commentList')) {
          commentModel.add(CommentModel.fromJson(comment));
        }

        print('$url - Successful');
        return true;;
      } else {
        throw Exception(ComnUtils.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }


  void addCommentToModel(List<CommentModel> commentModels, int? commentId, CommentModel newComment) {
    for (CommentModel commentItem in commentModels) {

      if (commentItem.commentId == commentId) {
        if (commentItem.childComments == null) {
          commentItem.childComments = [];
        }
        commentItem.childComments?.add(newComment);

        break;
      }
      CommentModel? targetParentItem;

      for (CommentModel commentItem in commentModels) { // 부모 리스트 반복
        if (commentItem.childComments?.any((child) => child.commentId == commentId) ?? false) {
          targetParentItem = commentItem;
          break;
        }
      }

      if (targetParentItem != null) {
        targetParentItem.childComments?.add(newComment);
        break;
      }
    }
  }


  List<CommentModel> flattenComments(List<CommentModel> parentComments) {
    List<CommentModel> flatList = [];

    for (var parentComment in parentComments) {
      flatList.add(parentComment);

      if (parentComment.childComments != null) {
        flatList.addAll(flattenComments(parentComment.childComments!));
      }
    }

    return flatList;
  }

  int findCommentIndex(List<CommentModel> parentComments, int targetCommentId) {

    List<CommentModel> flatComments = flattenComments(parentComments);

    return flatComments.indexWhere((comment) => comment.commentId == targetCommentId);
  }

  void fnUpdateCommentLike(CommentModel commentModel){

    commentModel.commentLikeStatus = !commentModel.commentLikeStatus!;

    if (commentModel.commentLikeStatus!) {
      commentModel.commentLikeCnt = commentModel.commentLikeCnt! + 1;
    } else {
      commentModel.commentLikeCnt = commentModel.commentLikeCnt! - 1;
    }

    notify();
  }
}
