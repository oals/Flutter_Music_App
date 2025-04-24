import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skrrskrr/model/comment/comment_model.dart';
import 'package:skrrskrr/utils/helpers.dart';

class CommentProv extends ChangeNotifier {

  List<CommentModel> commentModel = [];
  CommentModel childCommentModel = CommentModel();

  void notify() {
    notifyListeners();
  }

  Future<bool> setCommentLike(commentId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setCommentLike';

    try {
      http.Response response = await Helpers.apiCall(
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
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> setComment(trackId, String commentText,commentId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/setComment';

    try {
      http.Response response = await Helpers.apiCall(
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
        print('$url - Successful');
        return true;;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> getComment(trackId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getComment?trackId=${trackId}&loginMemberId=${loginMemberId}';

    try {
      http.Response response = await Helpers.apiCall(
          url
      );

      if (response.statusCode == 200) {

        commentModel = [];

        for (var comment in Helpers.extractValue(response.body, 'commentList')) {
          commentModel.add(CommentModel.fromJson(comment));
        }

        print('$url - Successful');
        return true;;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }

  Future<bool> getChildComment(commentId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url = '/api/getChildComment?commentId=${commentId}&loginMemberId=${loginMemberId}';

    try {
      http.Response response = await Helpers.apiCall(
          url
      );

      if (response.statusCode == 200) {
        
        childCommentModel = CommentModel();
        childCommentModel = CommentModel.fromJson(Helpers.extractValue(response.body, 'comment'));
        childCommentModel.childComment = [];

        for (var childComment in Helpers.extractValue(response.body, 'commentList')) {
          childCommentModel.childComment?.add(CommentModel.fromJson(childComment));
        }

        print('$url - Successful');
        return true;;
      } else {
        throw Exception(Helpers.extractValue(response.body, 'message'));
      }
    } catch (error) {
      print(error);
      print('$url - Fail');
      return false;
    }
  }
}
