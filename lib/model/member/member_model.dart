import 'package:json_annotation/json_annotation.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModel {

  int? memberId;

  String? memberEmail;

  String? memberNickName;

  String? memberInfo;

  String? memberBirth;

  String? memberAddr;

  String? memberDate;

  int? memberFollowCnt;

  int? memberFollowerCnt;

  String? memberImagePath;

  int? isFollowedCd;

  MemberModel();

  factory MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

}
