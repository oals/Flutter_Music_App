import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/track/track.dart';
import 'package:skrrskrr/screen/modal/child_comment.dart';
import 'package:skrrskrr/screen/modal/comment.dart';
import 'package:skrrskrr/screen/modal/my_play_list_modal.dart';
import 'package:skrrskrr/screen/modal/new_play_list.dart';
import 'package:skrrskrr/screen/modal/track_more_info.dart';
import 'package:skrrskrr/screen/appScreen/track/upload.dart';

// AppBottomRouter 클래스 정의
class AppBottomModalRouter {
  static void fnModalRouter(
      BuildContext context,
      int modalIndex, {
        String trackImagePath = "",
        int? trackId,
        int? commentId,
        Track? track,
      }) async {

    final Map<int, Future<dynamic> Function()> modalWidgets = {
      0: () async {
        return CommentScreen(trackId: trackId);
      },
      1: () async {
        // 파일 선택 처리
        FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(type: FileType.audio);
        if (selectedFile != null && selectedFile.files.isNotEmpty) {
          return Container(
            height: 100.h,
            child: UploadScreen(uploadTrackFile: selectedFile),
          );
        } else {
          print("파일이 선택되지 않았습니다.");
          return null;
        }
      },
      2: () async {
        return NewPlayListScreen();
      },
      3: () async {
        return TrackMoreInfoScreen(track: track!, fnBottomModal: fnBottomModal);
      },
      4: () async {
        return ChildCommentScreen(trackId: trackId, commentId: commentId);
      },
    };

    // Modal 위젯이 존재하면 showModalBottomSheet 호출
    if (modalWidgets.containsKey(modalIndex)) {
      dynamic modalFunction = modalWidgets[modalIndex];

      if (modalFunction != null) {
        Widget? modalContent = await modalFunction();

        if (modalContent != null) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return modalContent;
            },
          );
        }
      }
    }
  }

  // fnBottomModal을 추가했는데, 이를 필요에 맞게 사용
  static Future<int?> fnBottomModal(BuildContext context, int modalIndex, {int? trackId}) async {
    if (modalIndex == 0) {
      final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: MyPlayListModalScreen(trackId: trackId!),
          );
        },
      );
      return result;
    }
    return null;
  }
}
