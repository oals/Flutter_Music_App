import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/upload/upload.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/upload/upload_text_field_item.dart';
import 'package:skrrskrr/utils/comn_utils.dart';
import '../../../router/app_bottom_modal_router.dart';

class UploadModal extends StatefulWidget {
  const UploadModal({
    super.key,
    required this.isAlbum,
    required this.callBack,
  });
  final bool isAlbum;
  final Function callBack;

  @override
  State<UploadModal> createState() => _UploadModalState();
}

class _UploadModalState extends State<UploadModal> {
  final ScrollController _scrollController = ScrollController();

  bool _isToggled = false;
  Uint8List? _imageBytes;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController infoController = TextEditingController();
  final TextEditingController fileController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final FocusNode titleControllerFocusNode = FocusNode();
  final FocusNode infoControllerFocusNode = FocusNode();

  List<Upload> uploadTrackList = [];
  late String? title;
  late String? info;
  bool isPrivacy = false;
  int categoryId = 0;
  bool isUploading = false;

  @override
  void initState() {
    for (int i = 0; i < 1; i++) {
      Upload upload = Upload();
      upload.uploadFileNm = "";
      uploadTrackList.add(upload);
    }

    titleController.text = '';
    infoController.text = '';
    fileController.text = 'Select a file';
    categoryController.text = 'Select a category';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TrackProv trackProv = Provider.of<TrackProv>(context);

    void selectedFile(i) async {
      FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'mp4'],
      );

      if (selectedFile != null && selectedFile.files.isNotEmpty) {
        uploadTrackList[i].uploadFile = selectedFile;
        uploadTrackList[i].uploadFileNm = selectedFile.files.first.name;
        fileController.text = uploadTrackList[0].uploadFileNm!;
        setState(() {});
      } else {
        print("파일이 선택되지 않았습니다.");
        return null;
      }
    }

    void _saveTrackInfo() {
      title = titleController.text;
      info = infoController.text;
    }

    Future<void> _pickImage() async {
      try {

        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);

        if (image != null) {
          _imageBytes = await ComnUtils.cropImage(image.path);

          if (_imageBytes != null) {
            FilePickerResult filePickerResult = await ComnUtils.convertUint8ListToFilePickerResult(
              _imageBytes!,
              _imageBytes!.lengthInBytes,
            );

            uploadTrackList[0].uploadImage = filePickerResult;
            uploadTrackList[0].uploadImageNm = image.path.split('/').last;

            setState(() {});

          } else {
            print("이미지를 자르는 중 문제가 발생했습니다.");
          }
        } else {
          print("이미지가 선택되지 않았습니다.");
        }
      } catch (e) {
        print("이미지 선택 또는 처리 중 오류 발생: $e");
      }
    }

    return GestureDetector(
      onVerticalDragUpdate: isUploading ? (DragUpdateDetails details) {} : null,
      child: Container(
        width: 100.w,
        height: 100.h,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Stack(

            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!widget.isAlbum)...[
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Center(
                        child: Container(
                          height: 35.h,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)
                          ),
                          child: _imageBytes != null
                              ? Image.memory(
                            _imageBytes!,
                            width: 100.w,
                            height: 35.h,
                            fit: BoxFit.cover,
                          ): Center(
                            child: Text(
                              'Select Image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: UploadTextFieldItem(
                        label: "File",
                        maxLines: 1,
                        controller: fileController,
                        focusNode: null,
                        isReadOnly : true,
                        isOnTap : true,
                        callBack : ()=>{ selectedFile(0)},
                      ),
                    ),

                  ],

                  if (widget.isAlbum)...[
                    Container(
                      width: 100.w,
                      height: 35.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: _imageBytes != null // 선택된 이미지가 있을 경우
                                ? Image.memory(
                              _imageBytes!, // 선택된 이미지 표시
                              width: 100.w,
                              height: 35.h,
                              fit: BoxFit.cover,
                            ) : Center(
                              child: Text(
                                'Select Image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 5,bottom: 5,top: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.2, // 선의 두께
                            color: Colors.grey, // 선의 색상
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text('Album Tracks',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: 100.w,
                      child: Scrollbar(

                        controller: _scrollController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < uploadTrackList.length; i++)...[
                                  GestureDetector(
                                    onTap: () {
                                      if (uploadTrackList[i].uploadFile != null) {
                                        if (_imageBytes == null) {
                                          _pickImage();
                                        } else {
                                          selectedFile(i);
                                        }
                                      } else {
                                        selectedFile(i);
                                        Upload addUpload = new Upload();
                                        addUpload.uploadFileNm ='';
                                        uploadTrackList.add(addUpload);
                                      }
                                    },
                                    child: Container(
                                      width: 17.w,
                                      height: uploadTrackList[0].uploadFileNm! != '' ? 12.5.h : 11.h,
                                      padding: EdgeInsets.only(left: 7),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          uploadTrackList[i].uploadFile!= null && _imageBytes != null // 선택된 이미지가 있을 경우
                                              ? ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: Image.memory(
                                              _imageBytes!, // 선택된 이미지 표시
                                              width: 15.w,
                                              height: 9.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ) : uploadTrackList[i].uploadFile != null ?
                                          Container(
                                            width: 15.w,
                                            height: 9.h,
                                            decoration: BoxDecoration(
                                                color: Color(0x33ffffff),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Select Image',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12
                                                ),
                                                  textAlign : TextAlign.center,
                                              ),
                                            ),
                                          ) :
                                          Container(
                                            width: 15.w,
                                            height: 9.h,
                                            decoration: BoxDecoration(
                                                color: Color(0x33ffffff),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 10.w,
                                            ),
                                          ),
                                          if (uploadTrackList[i].uploadFileNm! != "")...[
                                            SizedBox(height: 5,),
                                            Text(
                                              uploadTrackList[i].uploadFileNm!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],

                                        ],
                                      ),
                                    ),
                                  ),

                                ],

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: UploadTextFieldItem(
                      label: "Category",
                      maxLines: 1,
                      controller: categoryController,
                      focusNode: null,
                      isReadOnly : true,
                      isOnTap : true,
                      callBack : () async {
                        await AppBottomModalRouter(isChild: true).fnModalRouter(
                            categoryId: categoryId - 1,
                            context,
                            6,
                            callBack:(int selectedCategoryId) {

                              categoryId = selectedCategoryId + 1;
                              categoryController.text = ComnUtils.getCategory(categoryId);

                            });
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: UploadTextFieldItem(
                      label: widget.isAlbum ? "Album Name" : "Title",
                      maxLines: 1,
                      controller: titleController,
                      focusNode: titleControllerFocusNode,
                      isReadOnly : false,
                      isOnTap : false,
                      callBack : ()=>{},
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: UploadTextFieldItem(
                      label: "Info",
                      maxLines: 4,
                      controller: infoController,
                      focusNode: infoControllerFocusNode,
                      isReadOnly : false,
                      isOnTap : false,
                      callBack : ()=>{},
                    ),
                  ),

                  SizedBox(height: 10),
                  if (!widget.isAlbum)
                    Container(
                      width: 97.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3,color: Color(0xff1c1c1c)),
                        color: Color(0xff1c1c1c),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap : () {
                              _isToggled = !_isToggled;
                              isPrivacy = _isToggled;
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  !_isToggled ? 'Public' : 'Private',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {

                      if (uploadTrackList[0].uploadFileNm == "") {
                        ComnUtils.customFlutterToast("Please select a file");
                        return;
                      }

                      if (categoryId == 0) {
                        ComnUtils.customFlutterToast("Please select a category");
                        return;
                      }

                      if (titleController.text.length == 0) {
                        ComnUtils.customFlutterToast("Please enter a title");
                        return;
                      }

                      _saveTrackInfo();
                      isUploading = true;
                      titleControllerFocusNode.unfocus();
                      infoControllerFocusNode.unfocus();
                      setState(() {});

                      if (widget.isAlbum) {
                        await trackProv.uploadAlbum(uploadTrackList,title!,info!,isPrivacy,categoryId);
                      } else {
                        await trackProv.uploadTrack(uploadTrackList,title!,info!,isPrivacy,categoryId);
                      }

                      ComnUtils.customFlutterToast("Successfully completed");

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.callBack();
                      });

                    },
                    child: Center(
                      child: Container(
                        width: 97.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3,color: Color(0xff1c1c1c)),
                          color: Color(0xff1c1c1c),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Upload',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              if (isUploading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AbsorbPointer(
                    absorbing: true, // 클릭 차단 활성화
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: CustomProgressIndicatorItem(),
                      ),
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }


}

