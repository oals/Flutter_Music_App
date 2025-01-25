import 'package:json_annotation/json_annotation.dart';

part 'follow_info_model.g.dart';

@JsonSerializable()
class FollowInfoModel {

  int? followMemberId;

  String? followNickName;

  String? followImagePath;

  bool? mutualFollow;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isFollow = false;

  int? isFollowedCd;

  FollowInfoModel();

  factory FollowInfoModel.fromJson(Map<String, dynamic> json) => _$FollowInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$FollowInfoModelToJson(this);

}