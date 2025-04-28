import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
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
        int? categoryId,
        bool? isAlbum,
        Function? callBack,
      }) async {

    OverlayEntry? parentOverlayEntry;
    DraggableScrollableController draggableScrollableController = DraggableScrollableController();



    // void _removeOverlay() {
    //   if(modalOverlayEntry != null){
    //     modalOverlayEntry?.remove();
    //     modalOverlayEntry = null;
    //   }
    // }

    void _removeOverlay() {
      if (parentOverlayEntry != null) {
        parentOverlayEntry?.remove();
        parentOverlayEntry = null;
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
        return SelectCategory(
            categoryId : categoryId,
          callBack: (int categoryIdList) {
            callBack!(categoryIdList);
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
          }
        );
      },
    };

    if (modalWidgets.containsKey(modalIndex)) {
      dynamic modalFunction = modalWidgets[modalIndex];


      double maxSize = 0.9;
      if(modalIndex == 1 || modalIndex == 5) {
        maxSize = 1.0;
      } else if (modalIndex == 7 ) {
        maxSize = 0.95;
      }

      void _showOverlay() async {

        Widget? modalContent = await modalFunction();
        OverlayEntry? childOverlayEntry;
        bool isClosing = false;
        double currentExtent = maxSize;

        parentOverlayEntry = OverlayEntry(
          builder: (context) {
            return Material(
              color: Colors.black.withOpacity(0.5), // 배경 색상
              child: Listener(
                onPointerUp: (details) {
                  if (!isClosing && currentExtent <= 0.8) {
                    isClosing = true;
                    Future.microtask(() {
                      childOverlayEntry = OverlayEntry(
                        builder: (context) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 1.0, end: 0.0),
                            duration: Duration(milliseconds: 650),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, value * 100.h),
                                child: child,
                              );
                            },
                            onEnd: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                parentOverlayEntry?.remove();
                                childOverlayEntry?.remove();
                              });


                            },
                          );
                        },
                      );
                      Overlay.of(context).insert(childOverlayEntry!);
                    });
                  }
                },
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    currentExtent = notification.extent;
                    return true;
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1.0, end: !isClosing ? 0.0 : 1.0),
                    duration: Duration(milliseconds: 650),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, value * 100.h),
                        child: DraggableScrollableSheet(
                          initialChildSize: maxSize,
                          minChildSize: 0.0,
                          maxChildSize: maxSize,
                          builder: (context, scrollController) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: modalContent!,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );

        Overlay.of(context).insert(parentOverlayEntry!);


      }

      _showOverlay();
    }
  }

}
