
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
import 'package:skrrskrr/screen/subScreen/upload/upload_text_field.dart';
import 'package:skrrskrr/utils/helpers.dart';

import '../../../router/app_bottom_modal_router.dart';

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
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  List<Upload> uploadTrackList = [];
  late String? title;
  late String? info;
  bool isPrivacy = false;
  int categoryCd = 0;

  @override
  void initState() {
    // TODO: implement initState
    for(int i = 0; i < 1; i++){
      Upload upload = Upload();
      upload.uploadFileNm = "음원 추가";
      uploadTrackList.add(upload);
    }

    controller1.text = '';
    controller2.text = '';
    controller3.text = '파일을 선택해주세요.';
    controller4.text = '카테고리를 선택해주세요.';


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

        controller3.text = uploadTrackList[0].uploadFileNm!;
        String fileName = uploadTrackList[0].uploadFileNm!;
        String fileNameWithoutExtension = fileName.split('.').first;
        controller1.text = fileNameWithoutExtension;


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


    return Container(
      width: 100.w,
      height: 150.h,
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
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
                    height: 20.h,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child:  _imageBytes != null // 선택된 이미지가 있을 경우
                          ? Image.memory(
                        _imageBytes!, // 선택된 이미지 표시
                        width: 90.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                      ): SvgPicture.asset(
                        'assets/images/upload_image.svg',
                        color: Color(0xffffffff),
                        width: 8.w,
                        height: 4.h,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: UploadTextField(
                  label: "파일 이름",
                  maxLines: 1,
                  controller: controller3,
                  isReadOnly : true,
                  isOnTap : true,
                  callBack : ()=>{ selectedFile(0)},
                ),
              ),

            ],

            if(widget.isAlbum)...[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){
                        _pickImage();
                      },
                      child: Container(
                        width: 40.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child:  _imageBytes != null // 선택된 이미지가 있을 경우
                              ? Image.memory(
                            _imageBytes!, // 선택된 이미지 표시
                            width: 40.w,
                            height: 20.h,
                          ) :SvgPicture.asset(
                            'assets/images/upload_image.svg',
                            color: Color(0xffffffff),
                            width: 8.w,
                            height: 4.h,
                          ),
                        ),
                      ),
                    ),

                    Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15,top: 30),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for(int i = 0; i < uploadTrackList.length; i++)...[
                                  GestureDetector(
                                    onTap: (){
                                      selectedFile(i);
                                    },
                                    child: Container(
                                      width: 20.w,
                                      child:Text(
                                        uploadTrackList[i].uploadFileNm ?? "null",
                                        // "1. test.mp3",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700
                                        ),
                                        overflow: TextOverflow.ellipsis,
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

                                    setState(() {});
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


            ],

            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: UploadTextField(
                label: "카테고리",
                maxLines: 1,
                controller: controller4,
                isReadOnly : true,
                isOnTap : true,
                callBack : ()=>{

                  // print('모달'),
                AppBottomModalRouter.fnModalRouter(context,6, callBack:(categoryNm,categoryIdx)=>{
                  controller4.text = categoryNm,
                  categoryCd = categoryIdx
                })


                },
              ),
            ),



            // Container(
            //   width: 100.w,
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         for (int i = 0; i < categoryList.length; i++) ...[
            //           GestureDetector(
            //             onTap: (){
            //               setState(() {
            //                 category = i;
            //               },
            //               );
            //             },
            //             child: Container(
            //               width: 60,
            //               height: 40,
            //               decoration: BoxDecoration(
            //                 color: i == category ?  Colors.black : Colors.white,
            //                 border: Border.all(width: 2.5, color: Colors.white),
            //                 borderRadius: BorderRadius.circular(20),
            //               ),
            //               child: Center(
            //                 child: Text(
            //                   categoryList[i],
            //                   style: TextStyle(
            //                     color: i == category ?  Colors.white : Colors.black,
            //                     fontWeight: FontWeight.w700,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(width: 5,),
            //         ]
            //       ],
            //     ),
            //   ),
            // ),





            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: UploadTextField(
                label: widget.isAlbum ? "앨범명" : "타이틀",
                maxLines: 1,
                controller: controller1,
                isReadOnly : false,
                isOnTap : false,
                callBack : ()=>{},
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: UploadTextField(
                label: widget.isAlbum ? "앨범 소개" : "곡 소개",
                maxLines: 4,
                controller: controller2,
                isReadOnly : false,
                isOnTap : false,
                callBack : ()=>{},
              ),
            ),



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
                await trackProv.uploadTrack(widget.isAlbum,uploadTrackList,title!,info!,isPrivacy,categoryCd);
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


}

