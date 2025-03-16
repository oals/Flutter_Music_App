import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/comment/comment_model.dart';
import 'dart:convert';
import 'package:skrrskrr/model/home/home_model.dart';
import 'package:skrrskrr/utils/helpers.dart';

class CommentProv extends ChangeNotifier {
  List<CommentModel> commentModel = [];
  CommentModel childCommentModel = CommentModel();

  void notify() {
    notifyListeners();
  }

  Future<bool> setCommentLike(commentId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/setCommentLike';
    try {

      // POST 요청
      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        body:{
          'loginMemberId': loginMemberId,
          'commentId': commentId,
        }, 
      );

      if (response['status'] == '200') {

        print('$url - Successful');
        return true;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }

  }


  Future<bool> setComment(trackId, String commentText,commentId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/setComment';

    try {

      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        body: {
          'loginMemberId': loginMemberId,
          'trackId': trackId.toString(),
          'commentText': commentText,
          'commentId': commentId,
        },
      );

      print('123123123');
      print(response['status']);
      if (response['status'] == '200') {
        print('1231231234');
        print('$url - Successful');
        print('1231231235');
        return true;;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }

  }

  Future<bool> getComment(trackId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getComment?trackId=${trackId}&loginMemberId=${loginMemberId}';


    try {
      final response = await Helpers.apiCall(
          url
      );

      if (response['status'] == '200') {

        commentModel = [];
        for (var comment in response['commentList']) {
          commentModel.add(CommentModel.fromJson(comment));
        }
        print('$url - Successful');
        return true;;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }

  }


  Future<bool> getChildComment(commentId) async {

    final String loginMemberId = await Helpers.getMemberId();
    final url= '/api/getChildComment?commentId=${commentId}&loginMemberId=${loginMemberId}';


    try {
      final response = await Helpers.apiCall(
          url
      );

      if (response['status'] == '200') {
        
        childCommentModel = CommentModel();
        childCommentModel = CommentModel.fromJson(response['comment']);
        childCommentModel.childComment = [];

        for(var childComment in response['childComment']){
          childCommentModel.childComment?.add(CommentModel.fromJson(childComment));
        }
        print('$url - Successful');
        return true;;
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('$url - Fail');
      return false;
    }

  }

}
