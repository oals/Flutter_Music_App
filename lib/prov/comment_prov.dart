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
    print(commentId);

    final String memberId = await Helpers.getMemberId();
    final url = 'setCommentLike';

    print('setCommentLike 호출');

    try {

      // POST 요청
      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        body:{
          'memberId': memberId,
          'commentId': commentId,
        }, 
      );

      if (response != null) {
    
        print(response);


      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }


  Future<bool> setComment(trackId, commentText,commentId) async {
    print(trackId);
    print(commentText);
    print(commentId);

    final String memberId = await Helpers.getMemberId();
    final url = 'setComment';

    print('setComment 호출');

    try {
      // 요청 본문에 포함할 데이터 설정

      // POST 요청
      final response = await Helpers.apiCall(
        url,
        method: "POST",
        headers: {'Content-Type': 'application/json'}, // JSON 형태로 전송
        body: {
          'memberId': memberId,
          'trackId': trackId.toString(),
          'commentText': commentText,
          'commentId': commentId,
        }, // JSON으로 변환하여 본문에 포함
      );

      if (response != null) {
     
        print(response);
      } else {
        // 오류 처리
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }

  Future<bool> getComment(trackId) async {


    print('getComment 호출');
    final String memberId = await Helpers.getMemberId();
    final url = 'getComment?trackId=${trackId}&memberId=${memberId}';


    try {
      final response = await Helpers.apiCall(
          url
      );

      if (response != null) {
        print(response);

        commentModel = [];
        for (var comment in response['commentList']) {
          commentModel.add(CommentModel.fromJson(comment));
        }

      } else {
        // 오류 처리
        throw Exception('Failed to load data');

      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }


  Future<bool> getChildComment(commentId) async {
    
    print('getChildComment 호출');
    
    final String memberId = await Helpers.getMemberId();
    final url = 'getChildComment?commentId=${commentId}&memberId=${memberId}';


    try {
      final response = await Helpers.apiCall(
          url
      );

      if (response != null) {
        
        childCommentModel = CommentModel();
        childCommentModel = CommentModel.fromJson(response['comment']);
        childCommentModel.childComment = [];

        for(var childComment in response['childComment']){
          childCommentModel.childComment?.add(CommentModel.fromJson(childComment));
        }


      } else {
        // 오류 처리
        throw Exception('Failed to load data');

      }
    } catch (error) {
      // 오류 처리
      print('Error: $error');
      return false;
    }

    return true;
  }

}
