import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/screen/subScreen/category/category_square_item.dart';

class SearchMainSubScreen extends StatefulWidget {
  const SearchMainSubScreen({
    super.key,
    required this.recentListenTrackHistory,
  });

  final List<String> recentListenTrackHistory;

  @override
  State<SearchMainSubScreen> createState() => _SearchMainSubScreenState();
}

class _SearchMainSubScreenState extends State<SearchMainSubScreen> {
  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recently Listened Track',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                // Text(
                //   'more',
                //   style: TextStyle(
                //       color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                // ),
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
                Text('All',
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
        

            SizedBox(height: 12.h,)
        
        
          ],
        ),
      ),
    );
  }
}
