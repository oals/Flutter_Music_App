import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/screen/modal/audio_player_track_list_modal.dart';
import 'package:skrrskrr/screen/modal/comment/comment.dart';
import 'package:skrrskrr/screen/modal/playList/my_play_list_modal.dart';
import 'package:skrrskrr/screen/modal/playList/new_play_list.dart';
import 'package:skrrskrr/screen/modal/track/info_edit_modal.dart';
import 'package:skrrskrr/screen/modal/track/track_more_info.dart';
import 'package:skrrskrr/screen/modal/upload/upload.dart';
import 'package:skrrskrr/screen/modal/upload/select_category.dart';

class AppBottomModalRouter {

  static void fnModalRouter(
      BuildContext context,
      int modalIndex,
      {
        String trackImagePath = "",
        int? trackId,
        int? commentId,
        int? maxLines,
        String? infoText,
        Track? track,
        int? categoryId,
        bool? isAlbum,
        Function? callBack,
      }) async {

    OverlayEntry? parentOverlayEntry;
    OverlayEntry? childOverlayEntry;
    bool isClosing = false;

    final GlobalKey listenerKey = GlobalKey();

    BuildContext? findContext(){
      final context = listenerKey.currentContext;

      if (context != null) {
        return context;
      }

      return null;
    }

    void removeOverlay(BuildContext? context){

      final buildContext = context == null ? findContext() : context;

      if(buildContext != null) {
        isClosing = true;

        Future.microtask(() {
          childOverlayEntry = OverlayEntry(
            builder: (context) {
              return TweenAnimationBuilder<double>(
                tween:  Tween<double>(begin: 1.0, end: 0.0),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.translate(
                      offset: Offset(0, value * 100.h),
                      child: child
                  );
                },
                onEnd: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    childOverlayEntry?.remove();
                    parentOverlayEntry?.remove();
                  });
                },
              );
            },
          );
          Overlay.of(buildContext).insert(childOverlayEntry!);
        });
      }
    }

    final Map<int, Future<dynamic> Function()> modalWidgets = {
      0: () async {return CommentScreen(
            trackId: trackId,
            notificationCommentId : commentId,
            callBack: () {
              callBack!();
              removeOverlay(null);
            }
          );
        },
      1: () async {return InfoEditModal(
          infoText: infoText!,
          maxLines : maxLines,
          onSave: (String newTrackInfo) {
            callBack!(newTrackInfo);
            removeOverlay(null);
          }
        );
        },
      2: () async {return NewPlayListScreen();},
      3: () async {return TrackMoreInfoScreen(track: track!);},
      5: () async {return UploadScreen(
            isAlbum : isAlbum!,
            callBack: () {
              removeOverlay(null);
            }
          );
        },
      6: () async {return SelectCategory(
            categoryId : categoryId,
            callBack: (int categoryIdList) {
              callBack!(categoryIdList);
              removeOverlay(null);
            },
          );
      },
      7: () async {return AudioPlayerTrackListModal();},
      8: () async {return MyPlayListModalScreen(
          trackId: trackId!,
          callBack : (int? playListId) {
            callBack!(playListId);
            removeOverlay(null);
          }
        );
      },
    };

    if (modalWidgets.containsKey(modalIndex)) {
      dynamic modalFunction = modalWidgets[modalIndex];

      double maxSize = 0.9;
      if (modalIndex == 5) {
        maxSize = 1.0;
      } else if (modalIndex == 7 ) {
        maxSize = 0.95;
      }

      void _showOverlay() async {
        Widget? modalContent = await modalFunction();
        childOverlayEntry = null;
        isClosing = false;
        double currentExtent = 1.0;

        parentOverlayEntry = OverlayEntry(
          builder: (context) {
            return Material(
              color: Colors.black.withOpacity(0.5), // 배경 색상
              child: Listener(
                key: listenerKey,
                onPointerUp: (details) {
                  if (!isClosing && currentExtent <= 0.9) {
                    isClosing = true;
                    removeOverlay(context);
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
                                color: Colors.transparent,
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
