import 'package:json_annotation/json_annotation.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

import 'package:skrrskrr/model/track/track.dart';


part 'home_model.g.dart';
@JsonSerializable()
class HomeModel {
  int? topicIdx;
  int? homeCategory;
  String? topic;
  List<String>? topicCategoryList;
  List<String>? topicList;

  HomeModel({
    this.topicIdx,
    this.homeCategory,
    this.topic,
    this.topicCategoryList,
    this.topicList,
  });

  // JSON으로부터 HomeModel 인스턴스를 생성하는 팩토리 메서드
  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);

  // HomeModel 인스턴스를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}
