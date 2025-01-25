
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skrrskrr/model/comn/upload.dart';
import 'package:skrrskrr/prov/track_prov.dart';
import 'package:skrrskrr/utils/helpers.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    super.key,
    required this.uploadTrackFile,
  });

  final FilePickerResult? uploadTrackFile;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? fileName;
  bool _isToggled = false;
  Uint8List? _imageBytes; // 선택된 이미지의 바이트 데이터
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();



  @override
  Widget build(BuildContext context) {

    TrackProv trackProv = Provider.of<TrackProv>(context);
    Upload upload = trackProv.model;

    upload.uploadFile = widget.uploadTrackFile;
    upload.uploadFileNm = widget.uploadTrackFile?.files.first.name;

    void _saveTrackInfo() {
      upload.trackNm = controller1.text;
      upload.trackInfo = controller2.text;
    }




    Future<void> _pickImage() async {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // 이미지 파일만 선택
      );

      if (result != null && result.files.isNotEmpty) {


        _imageBytes = await Helpers.cropImage(result.files.first.path!);

        FilePickerResult filePickerResult = await Helpers.convertUint8ListToFilePickerResult(_imageBytes!,result.files.first.size);

        upload.uploadImage = filePickerResult;
        upload.uploadImageNm = result.files.first.name ?? "";

        setState(() {});

      }
    }





    List<String> categoryList = [
      'K-Pop',
      'HipHop',
      'Beats',
      'Rock',
      'R&B',
      'Ballad',
      'Dj',
    ];

    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff2d1640), // 상단의 연한 색 (색상값을 조정하세요)
            Color(0xff8515e7), // 하단의 어두운 색 (현재 색상)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff2d1640), // 상단의 연한 색
              Color(0xffffe00),    // 하단의 어두운 색
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 75),
              GestureDetector(
                onTap: (){
                  _pickImage();
                },
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child:  _imageBytes != null // 선택된 이미지가 있을 경우
                        ? Image.memory(
                      _imageBytes!, // 선택된 이미지 표시
                      width: 280,
                      height: 280,
                      fit: BoxFit.cover,
                    ) : Image.asset(
                      'assets/images/testImage.png', // 기본 이미지
                      width: 280,
                      height: 280,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              /// 업로드 프로그래스바
              /// 업로드 버튼 누를 시 프로그래스 바 나타나게 설정 - 업로드 끝나면 초록색으로 변경
              // Container(
              //   width: maxWidth * 0.7,
              //   child: LinearProgressIndicator(
              //     value: null, // null이면 무한 루프 프로그레스 바
              //     minHeight: 6, // 프로그레스 바의 높이
              //     valueColor: AlwaysStoppedAnimation<Color>(Color(0xff8515e7)), // 색상 설정
              //   ),
              // ),
              SizedBox(height: 15),
              Container(
                width: 70.w,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5, // 아이템 간의 수평 간격
                  runSpacing: 5, // 줄 간의 수직 간격
                  children: [
                    for (int i = 0; i < categoryList.length; i++) ...[
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            upload.trackCategoryId = i;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 40,


                          decoration: BoxDecoration(

                            gradient: LinearGradient(
                              colors: [
                                Color(0xff200f3a), // 상단의 연한 색 (색상값을 조정하세요)
                                Color(0xff2d1640), // 하단의 어두운 색 (현재 색상)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),

                            // color: i == upload.trackCategoryId ? Color(0xff8515e7) : Color(0xff200f2e),
                            // border: Border.all(width: 1, color: Color(0xff8515e7)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              categoryList[i],
                              style: TextStyle(
                                color: i == upload.trackCategoryId ?  Colors.purple : Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              SizedBox(height: 15),
              buildInputFields(),
              SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 48.w,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3,color: Colors.black12),
                      color: Color(0xff2d1640),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/album.svg',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '내 앨범에 추가',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    width: 48.w,
                    height: 60,
                    child: GestureDetector(
                      onTap : (){
                        setState(() {
                          _isToggled = !_isToggled;
                          upload.isTrackPrivacy = _isToggled;

                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3,color: Colors.black12),
                          color: Color(0xff2d1640),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: Text(
                              !_isToggled ? '공개' : '비공개',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),



              SizedBox(height: 25),
              GestureDetector(
                onTap: () async {
                  _saveTrackInfo();
                  print('업로드 버튼 클릭');
                  await trackProv.uploadTrack();
                  Fluttertoast.showToast(msg: "업로드 되었습니다.");

                  Navigator.pop(context);

                },
                child: Center(
                  child: Container(
                    width: 97.w,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3,color: Colors.black12),
                      color: Color(0xff2d1640),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '업로드',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5),
                      ),
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

  Widget buildInputFields() {


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: CustomInputField(
            label: '제목',
            maxLines: 1,
            controller: controller1,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: CustomInputField(
            label: '곡 설명',
            maxLines: 4,
            controller: controller2,
          ),
        ),
      ],
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final int? maxLines;
  final TextEditingController controller;

  CustomInputField({required this.label, required this.maxLines, required this.controller });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
