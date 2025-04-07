
import 'package:skrrskrr/model/follow/follow_info_model.dart';
import 'package:skrrskrr/model/member/member_model.dart';
import 'package:skrrskrr/model/playList/play_list_info_model.dart';
import 'package:skrrskrr/model/track/track.dart';

class SearchModel {

  String? searchText;

  int? totalCount;

  String? status;

  List<Track> trackList = [];

  List<FollowInfoModel> memberList = [];
  int? memberListCnt = 0;

  List<PlayListInfoModel> playListList = [];
  int? playListListCnt = 0;
}