// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      topicIdx: (json['topicIdx'] as num?)?.toInt(),
      homeCategory: (json['homeCategory'] as num?)?.toInt(),
      topic: json['topic'] as String?,
      topicCategoryList: (json['topicCategoryList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      topicList: (json['topicList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'topicIdx': instance.topicIdx,
      'homeCategory': instance.homeCategory,
      'topic': instance.topic,
      'topicCategoryList': instance.topicCategoryList,
      'topicList': instance.topicList,
    };
