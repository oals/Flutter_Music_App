import 'package:json_annotation/json_annotation.dart';

part 'search_history_model.g.dart';

@JsonSerializable()
class SearchHistoryModel {

  String? historyText;

  String? historyDate;

  SearchHistoryModel();

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) => _$SearchHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryModelToJson(this);

}