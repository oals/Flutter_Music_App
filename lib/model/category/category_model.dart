
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart'; // 생성될 파일

@JsonSerializable()
class CategoryModel {

  int? trackCategoryId;

  String? trackCategoryNm;

  CategoryModel();

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}