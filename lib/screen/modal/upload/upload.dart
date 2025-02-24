
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
      upload.uploadFileNm = "";
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
        if(!widget.isAlbum) {
          controller1.text = fileNameWithoutExtension;
        }



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


            if(!widget.isAlbum)...[

              GestureDetector(
                onTap: (){
                  _pickImage();
                },
                child: Center(
                  child: Container(
                    height: 35.h,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: _imageBytes != null // 선택된 이미지가 있을 경우
                        ? Image.memory(
                      _imageBytes!, // 선택된 이미지 표시
                      width: 100.w,
                      height: 35.h,
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
                width: 100.w,
                height: 35.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        _pickImage();
                      },
                      child: _imageBytes != null // 선택된 이미지가 있을 경우
                          ? Image.memory(
                        _imageBytes!, // 선택된 이미지 표시
                        width: 100.w,
                        height: 35.h,
                        fit: BoxFit.cover,
                      ) :SvgPicture.asset(
                        'assets/images/upload_image.svg',
                        color: Color(0xffffffff),
                        width: 8.w,
                        height: 4.h,
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
                      child: Text('앨범 수록곡',
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
                          for(int i = 0; i < uploadTrackList.length; i++)...[
                            GestureDetector(
                              onTap: (){

                                if(uploadTrackList[i].uploadFile != null) {
                                  if(_imageBytes == null){
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
                                height: 11.h,
                                padding: EdgeInsets.only(left: 7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    uploadTrackList[i].uploadFile!= null && _imageBytes != null // 선택된 이미지가 있을 경우
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.memory(
                                            _imageBytes!, // 선택된 이미지 표시
                                            width: 15.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ) : uploadTrackList[i].uploadFile != null ?
                                      Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child: SvgPicture.asset(
                                          'assets/images/upload_image.svg',
                                          color: Color(0xffffffff),
                                          width: 15.w,
                                          height: 3.h,
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
                                    if(uploadTrackList[i].uploadFileNm! != "")...[
                                      SizedBox(height: 5,),
                                      Text(
                                        uploadTrackList[i].uploadFileNm!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                          ],

                        ],
                      ),
                    ),
                  ),
                ),
              ),


            ],

            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: UploadTextField(
                label: "카테고리",
                maxLines: 1,
                controller: controller4,
                isReadOnly : true,
                isOnTap : true,
                callBack : ()=>{

                AppBottomModalRouter.fnModalRouter(context,6, callBack:(categoryNm,categoryIdx)=>{
                  controller4.text = categoryNm,
                  categoryCd = categoryIdx
                })

                },
              ),
            ),







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



            SizedBox(height: 10),
            if(!widget.isAlbum)
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
                        onTap : (){
                          setState(() {
                            _isToggled = !_isToggled;
                            isPrivacy = _isToggled;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              child:  !_isToggled ? SvgPicture.asset(
                                'assets/images/lock_on.svg',
                                width: 2.5.w,
                                height: 2.5.h,
                                color: Colors.white,
                              ) : SvgPicture.asset(
                                'assets/images/lock_off.svg',
                                width: 2.5.w,
                                height: 2.5.h,
                                color: Colors.white,
                              )
                            ),
                            SizedBox(width: 1.5,),
                            Text( !_isToggled ? '공개' : '비공개',
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
                _saveTrackInfo();
                await trackProv.uploadTrack(widget.isAlbum,uploadTrackList,title!,info!,isPrivacy,categoryCd);
                Fluttertoast.showToast(msg: "업로드 되었습니다.");
                Navigator.pop(context);
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
                      '업로드',
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
      ),
    );
  }


}

