
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
    // required this.uploadTrackFile,
    required this.isAlbum,
  });
  final bool isAlbum;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _isToggled = false;
  Uint8List? _imageBytes; // 선택된 이미지의 바이트 데이터
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  List<Upload> uploadTrackList = [];
  late String? title;
  late String? info;
  bool isPrivacy = false;
  int category = 0;

  @override
  void initState() {
    // TODO: implement initState
    for(int i = 0; i < 4; i++){
      Upload upload = Upload();
      upload.uploadFileNm = "음원 추가";
      uploadTrackList.add(upload);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TrackProv trackProv = Provider.of<TrackProv>(context);

    void selectedFile(i) async {
      FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (selectedFile != null && selectedFile.files.isNotEmpty) {
        uploadTrackList[i].uploadFile = selectedFile;
        uploadTrackList[i].uploadFileNm = selectedFile.files.first.name;

        setState(() {});
      } else {
        print("파일이 선택되지 않았습니다.");
        return null;
      }
    }

    void _saveTrackInfo() {
      title = controller1.text;
      info = controller2.text;
    }

    Future<void> _pickImage() async {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // 이미지 파일만 선택
      );

      if (result != null && result.files.isNotEmpty) {

        _imageBytes = await Helpers.cropImage(result.files.first.path!);

        FilePickerResult filePickerResult = await Helpers.convertUint8ListToFilePickerResult(_imageBytes!,result.files.first.size);

        uploadTrackList[0].uploadImage = filePickerResult;
        uploadTrackList[0].uploadImageNm = result.files.first.name ?? "";

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
      height: 150.h,
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 35),
            Container(
              decoration: BoxDecoration(
                color: Colors.white, //0xff8515e7
                borderRadius: BorderRadius.circular(30),
              ),
              width: 50,
              height: 8,
            ),
            if(!widget.isAlbum)...[
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  _pickImage();
                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 3),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child:  _imageBytes != null // 선택된 이미지가 있을 경우
                          ? Image.memory(
                        _imageBytes!, // 선택된 이미지 표시
                        width: 40.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ) : Image.asset(
                        'assets/images/testImage.png', // 기본 이미지
                        width: 40.w,
                        height: 20.h,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),


              GestureDetector(
                onTap:(){
                  selectedFile(0);
                },
                child: Container(
                  width: 70.w,
                  height: 5.h,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 2,color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Icon(Icons.music_video_sharp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5,),
                          Container(
                            child:Text(
                              uploadTrackList[0].uploadFileNm!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Icon(Icons.add,
                          color: Colors.white,
                        ),

                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),
            ],

            if(widget.isAlbum)...[
              Container(
                height: 35.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 35,),
                        GestureDetector(
                          onTap: (){
                            _pickImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey,width: 3),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child:  _imageBytes != null // 선택된 이미지가 있을 경우
                                  ? Image.memory(
                                _imageBytes!, // 선택된 이미지 표시
                                width: 40.w,
                                height: 20.h,
                                fit: BoxFit.cover,
                              ) : Image.asset(
                                'assets/images/testImage.png', // 기본 이미지
                                width: 40.w,
                                height: 20.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: (){
                            _pickImage();
                          },
                          child: Container(
                            width: 44 .w,
                            height: 5.h,
                            padding: EdgeInsets.only(left: 10,right: 10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(width: 2,color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(Icons.image,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      width: 25.w,
                                      child:Text(
                                        uploadTrackList[0].uploadImageNm ?? "이미지 선택",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),


                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Container(
                            child: Column(
                              children: [
                                // SizedBox(height: 35,),
                                for(int i = 0; i < uploadTrackList.length; i++)...[
                                  GestureDetector(
                                    onTap: (){
                                      selectedFile(i);
                                    },
                                    child: Container(
                                      width: 40.w,
                                      height: 5.h,
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(width: 2,color: Colors.grey),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Icon(Icons.music_video_sharp,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Container(
                                                width: 20.w,
                                                child:Text(
                                                  uploadTrackList[i].uploadFileNm ?? "null",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Icon(Icons.add,
                                              color: Colors.white,
                                            ),

                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                ],
                                GestureDetector(
                                  onTap: (){
                                    Upload addUpload = new Upload();
                                    addUpload.uploadFileNm ='테스트';
                                    uploadTrackList.add(addUpload);
                                    setState(() {

                                    });
                                  },
                                  child: Icon(Icons.add,
                                    color: Colors.white,
                                      size: 30,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )


                  ],
                ),
              ),
              SizedBox(height: 15),




              // Wrap(
              //   spacing: 15.0,
              //   runSpacing: 20.0,
              //   alignment: WrapAlignment.spaceBetween,
              //   children: List.generate(uploadTrackList.length, (index) {
              //     return GestureDetector(
              //       onTap: (){
              //         selectedFile(index);
              //       },
              //       child: Container(
              //         width: 40.w,
              //         height: 5.h,
              //         padding: EdgeInsets.only(left: 10,right: 10),
              //         decoration: BoxDecoration(
              //             color: Colors.black,
              //             border: Border.all(width: 2,color: Colors.grey),
              //             borderRadius: BorderRadius.circular(10)
              //         ),
              //         child:Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Row(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   child: Icon(Icons.music_video_sharp,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //                 SizedBox(width: 5,),
              //                 Container(
              //                   width: 20.w,
              //                   child:Text(
              //                     uploadTrackList[index].uploadFileNm ?? "null",
              //                     style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 16,
              //                         fontWeight: FontWeight.w700
              //                     ),
              //                     overflow: TextOverflow.ellipsis,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Container(
              //               child: Icon(Icons.add,
              //                 color: Colors.white,
              //               ),
              //
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),

              SizedBox(height: 15),
            ],


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
                          category = i;
                        },
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          color: i == category ?  Colors.black : Colors.white,
                          // color: i == upload.trackCategoryId ? Color(0xff8515e7) : Color(0xff200f2e),
                          // border: Border.all(width: 1, color: Color(0xff8515e7)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            categoryList[i],
                            style: TextStyle(
                              color: i == category ?  Colors.white : Colors.black,
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
                if(!widget.isAlbum)
                  Container(
                  width: 48.w,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3,color: Colors.black12),
                    color: Colors.white,
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
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '내 앨범에 추가',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                  ),
                ),
                Container(
                  width: 48.w,
                  height: 60,
                  child: GestureDetector(
                    onTap : (){
                      setState(() {
                        _isToggled = !_isToggled;
                        isPrivacy = _isToggled;

                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 3,color: Colors.black12),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                          child: Text(
                            !_isToggled ? '공개' : '비공개',
                            style: TextStyle(
                                color: Colors.black,
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
                await trackProv.uploadTrack(widget.isAlbum,uploadTrackList,title!,info!,isPrivacy,category);
                Fluttertoast.showToast(msg: "업로드 되었습니다.");
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  width: 97.w,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3,color: Colors.black12),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '업로드',
                      style: TextStyle(
                          color: Colors.black,
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
    );
  }

  Widget buildInputFields() {


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: CustomInputField(
            label: widget.isAlbum ? '앨범 제목' : '곡 제목',
            maxLines: 1,
            controller: controller1,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: CustomInputField(
            label: widget.isAlbum ? '앨범 소개' : '곡 소개',
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
