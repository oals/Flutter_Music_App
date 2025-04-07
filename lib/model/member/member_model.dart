import 'package:json_annotation/json_annotation.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/track/track.dart';

part 'member_model.g.dart'; // 생성될 파일

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

  List<Track>? popularTrackList = [];
  List<PlayListInfoModel> playListList = [];
  int? playListListCnt;
  List<Track>? allTrackList = [];
  int? allTrackListCnt;

  int? isFollowedCd;


  MemberModel();

  factory MemberModel.fromJson(Map<String, dynamic> json) => _$MemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
