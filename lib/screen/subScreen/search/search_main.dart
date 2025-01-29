import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/screen/subScreen/category/category_square_item.dart';
import 'package:skrrskrr/screen/subScreen/track/track_list_item.dart';

class SearchMainScreen extends StatefulWidget {
  const SearchMainScreen({
    super.key,
    required this.popularTrackHistory,
    required this.onTap,
    
    
  });

  final List<String> popularTrackHistory;
  final Function onTap;
  
  

  @override
  State<SearchMainScreen> createState() => _SearchMainScreenState();
}

class _SearchMainScreenState extends State<SearchMainScreen> {
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 68.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 들은 트랙',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  '더보기',
                  style: TextStyle(
                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // TrackListItem(trackItem: [],  fnRouter: widget.fnRouter),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          // 원하는 둥글기 조정
                          child: Image.asset(
                            'assets/images/testImage.png',
                            width: 50,
                            height: 50,
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'test1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width :5 ),
                                SvgPicture.asset(
                                  'assets/images/heart_red.svg',
                                  color: Color(0xffff0000),
                                  width: 15,
                                  height: 15,
                                ),
                              ],
                            ),
                              Row(
                                children: [


                                  Text(
                                    '오민규',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                 
                                ],
                              ),

                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {

                      },
                      child: SvgPicture.asset(
                        'assets/images/ellipsis.svg',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.09,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          // 원하는 둥글기 조정
                          child: Image.asset(
                            'assets/images/testImage.png',
                            width: 50,
                            height: 50,
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'test1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width :5 ),
                                SvgPicture.asset(
                                  'assets/images/heart_red.svg',
                                  color: Color(0xffff0000),
                                  width: 15,
                                  height: 15,
                                ),
                              ],
                            ),
                            Row(
                              children: [


                                Text(
                                  '오민규',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {

                      },
                      child: SvgPicture.asset(
                        'assets/images/ellipsis.svg',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.09,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          // 원하는 둥글기 조정
                          child: Image.asset(
                            'assets/images/testImage.png',
                            width: 50,
                            height: 50,
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'test1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width :5 ),
                                SvgPicture.asset(
                                  'assets/images/heart_red.svg',
                                  color: Color(0xffff0000),
                                  width: 15,
                                  height: 15,
                                ),
                              ],
                            ),
                            Row(
                              children: [


                                Text(
                                  '오민규',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {

                      },
                      child: SvgPicture.asset(
                        'assets/images/ellipsis.svg',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.09,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          // 원하는 둥글기 조정
                          child: Image.asset(
                            'assets/images/testImage.png',
                            width: 50,
                            height: 50,
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'test1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width :5 ),
                                SvgPicture.asset(
                                  'assets/images/heart_red.svg',
                                  color: Color(0xffff0000),
                                  width: 15,
                                  height: 15,
                                ),
                              ],
                            ),
                            Row(
                              children: [


                                Text(
                                  '오민규',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),

                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {

                      },
                      child: SvgPicture.asset(
                        'assets/images/ellipsis.svg',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.09,
                      ),
                    ),
                  ),
                ),
              ],
            ),


            /** 테스트 코드 */



            SizedBox(
              height: 15,
            ),

            Container(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('전체',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 20),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    CategorySquareItem(imageWidth: 30, imagePath:   'assets/images/testImage3.png', imageText: "", imageSubText: "Beat"),
                    SizedBox(width: 10,),
                    CategorySquareItem(imageWidth: 30, imagePath:   'assets/images/testImage4.png', imageText: "", imageSubText: "Ballad"),
                    SizedBox(width: 10,),
                    CategorySquareItem(imageWidth: 30, imagePath:   'assets/images/testImage5.png', imageText: "", imageSubText: "Rock"),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategorySquareItem(imageWidth: 46, imagePath:   'assets/images/testImage6.png', imageText: "", imageSubText: "Hip-Hop"),

                    SizedBox(width: 10,),

                    CategorySquareItem(imageWidth: 46, imagePath:   'assets/images/testImage7.png', imageText: "", imageSubText: "K-Pop"),

                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage8.png', imageText: "", imageSubText: "Beat"),
                    SizedBox(width: 4,),
                    CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage9.png', imageText: "", imageSubText: "DJ"),
                    SizedBox(width: 4,),
                    CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage10.png', imageText: "", imageSubText: "Rock"),
                    SizedBox(width: 4,),
                    CategorySquareItem(imageWidth: 22, imagePath:   'assets/images/testImage3.png', imageText: "", imageSubText: "Rock"),
                  ],
                ),
              ],
            ),
            ),




          ],
        ),
      ),
    );
  }
}
