import 'package:json_annotation/json_annotation.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';

part 'play_list_model.g.dart'; // 생성될 파일

@JsonSerializable()
class PlayListModel {

  String? playListNm;
  String? playListImagePath;
  int? playListId;
  int? memberId;
  String? memberNickName;
  bool? isPlayListPrivacy;
  bool? isInPlayList;
  bool? playListLike;
  int? trackCnt;

  PlayListModel();

  factory PlayListModel.fromJson(Map<String, dynamic> json) => _$PlayListModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayListModelToJson(this);


}