import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/prov/app_prov.dart';
import 'package:skrrskrr/screen/modal/audio_player_track_list_modal.dart';
import 'package:skrrskrr/screen/modal/comment/child_comment.dart';
import 'package:skrrskrr/screen/modal/comment/comment.dart';
import 'package:skrrskrr/screen/modal/playList/my_play_list_modal.dart';
import 'package:skrrskrr/screen/modal/playList/new_play_list.dart';
import 'package:skrrskrr/screen/modal/track/track_more_info.dart';
import 'package:skrrskrr/screen/modal/upload/upload.dart';
import 'package:skrrskrr/screen/modal/upload/select_category.dart';

// AppBottomRouter 클래스 정의
class AppBottomModalRouter {

  static void fnModalRouter(
      BuildContext context,
      int modalIndex,
      {
        String trackImagePath = "",
        int? trackId,
        int? commentId,
        Track? track,
        bool? isAlbum,
        Function? callBack,
      }) async {

    OverlayEntry? modalOverlayEntry;
    DraggableScrollableController draggableScrollableController = DraggableScrollableController();

    void _removeOverlay() {
      if(modalOverlayEntry != null){
        modalOverlayEntry?.remove();
        modalOverlayEntry = null;
      }
    }
    final Map<int, Future<dynamic> Function()> modalWidgets = {
      0: () async {
        return CommentScreen(trackId: trackId);
      },
      1: () async {
        // 파일 선택 처리
        return UploadScreen(isAlbum: false,);
      },
      2: () async {
        return NewPlayListScreen();
      },
      3: () async {
        return TrackMoreInfoScreen(track: track!);
      },
      4: () async {
        return ChildCommentScreen(trackId: trackId, commentId: commentId);
      },
      5: () async {
        return UploadScreen(isAlbum : isAlbum!);
      },
      6: () async {
        return SelectCategory(callBack: (String categoryNm, int index) {
          callBack!(categoryNm, index);
          _removeOverlay();
          },
        );
      },
      7: () async {
        return AudioPlayerTrackListModal();
      },
      8: () async {
        return MyPlayListModalScreen(
          trackId: trackId!,
          callBack : (int? playListId) {
            callBack!(playListId);
            _removeOverlay();
          }
        );
      }
    };

    if (modalWidgets.containsKey(modalIndex)) {
      dynamic modalFunction = modalWidgets[modalIndex];

      var maxSize = 0.9;
      if(modalIndex == 1 || modalIndex == 5) {
        maxSize = 1.0;
      } else if (modalIndex == 7 ) {
        maxSize = 0.95;
      }

      void _showOverlay(BuildContext context) async {
        Widget? modalContent = await modalFunction();

        modalOverlayEntry = OverlayEntry(
          builder: (context) => Material(
            color: Colors.transparent,
            child: Listener(
              onPointerUp: (event) {
                if (modalOverlayEntry != null && draggableScrollableController.size <= 0.75) {
                  _removeOverlay();
                }
              },
              child: Container(
                  color: Colors.transparent,
                  child: DraggableScrollableSheet(
                    snap: true,
                    snapSizes: [0.0, maxSize],
                    initialChildSize: maxSize,
                    minChildSize: 0.0,
                    maxChildSize: maxSize,
                    controller: draggableScrollableController,
                    builder: (BuildContext context, scrollController) {
                      return SingleChildScrollView(
                          controller: scrollController,
                          child: modalContent!
                      );
                    },
                  ),
                ),
              ),
            ),
          );

        if (!modalOverlayEntry!.maintainState) {
          Overlay.of(context).insert(modalOverlayEntry!);
        }
      }
      _showOverlay(context);
    }
  }

}
