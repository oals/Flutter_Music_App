import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:skrrskrr/prov/track_prov.dart';

class ComnLoadProv extends ChangeNotifier{

  bool isApiCall = false;
  int offset = 0;

  void notify() {
    notifyListeners();
  }

  void clear() {
    isApiCall = false;
  }


  Future<void> loadMoreData(dynamic provider,String apiName, int offset, {searchText,memberId, playListId, isAlbum, trackId}) async {
    if (!isApiCall) {
      setApiCallStatus(true);
      await Future.delayed(Duration(seconds: 3));  // API 호출 후 지연 처리
      if (apiName == 'UploadTrack') {
        await provider.getUploadTrack(offset);
      } else if (apiName == 'LikeTrack'){
        await provider.getLikeTrack(offset);
      } else if(apiName == 'MemberPageTrack') {
        await provider.getMemberPageTrack(memberId,offset);
      } else if (apiName == 'SearchTrack') {
        await provider.getSearchTrack(searchText,offset);
      } else if (apiName == 'SearchMember') {
        await provider.getSearchMember(searchText,offset,20);
      } else if (apiName == 'SearchPlayList') {
        await provider.getSearchPlayList(searchText,offset,20);
      } else if (apiName == 'MemberPagePlayList') {
        await provider.getMemberPagePlayList(memberId,offset,20);
      } else if (apiName == 'PlayListTrackList') {
        await provider.getPlayListTrackList(playListId,offset);
      } else if (apiName == "PlayLists") {
        await provider.getPlayList(trackId, offset, isAlbum);
      } else if (apiName == "LikePlayLists") {
        await provider.getLikePlayList(offset, isAlbum);
      }



      setApiCallStatus(false);
    }
  }

  bool shouldLoadMoreData(ScrollNotification notification) {
    return notification is ScrollUpdateNotification &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  void setApiCallStatus(bool status) {
    isApiCall = status;
    notify();
  }

  void resetApiCallStatus() {
    isApiCall = false;
    notify();
  }


}