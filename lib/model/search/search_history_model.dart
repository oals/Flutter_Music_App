

import 'package:json_annotation/json_annotation.dart';

part 'search_history_model.g.dart'; // 생성될 파일

@JsonSerializable()
class SearchHistoryModel {

  int? memberId;

  String? historyText;

  String? historyDate;


  SearchHistoryModel();

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) => _$SearchHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchHistoryModelToJson(this);
}