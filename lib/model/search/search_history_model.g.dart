// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHistoryModel _$SearchHistoryModelFromJson(Map<String, dynamic> json) =>
    SearchHistoryModel()
      ..memberId = (json['memberId'] as num?)?.toInt()
      ..historyText = json['historyText'] as String?
      ..historyDate = json['historyDate'] as String?;

Map<String, dynamic> _$SearchHistoryModelToJson(SearchHistoryModel instance) =>
    <String, dynamic>{
      'memberId': instance.memberId,
      'historyText': instance.historyText,
      'historyDate': instance.historyDate,
    };
