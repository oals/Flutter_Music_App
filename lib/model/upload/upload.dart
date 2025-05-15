
import 'package:file_picker/file_picker.dart';

class Upload {

  int? memberId;

  int? trackId;

  String? trackNm;

  String? albumNm;

  String? albumInfo;

  String? trackInfo;

  String? trackTime;

  int trackCategoryId = 0;

  int? albumId;

  bool isTrackPrivacy = false;

  FilePickerResult? uploadFile; // 업로드할 파일

  FilePickerResult? uploadImage; // 업로드할 이미지

  String? uploadFileNm; // 파일 이름

  String? uploadImageNm; // 이미지 이름



}
