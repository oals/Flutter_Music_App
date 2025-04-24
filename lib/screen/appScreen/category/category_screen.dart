import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/screen/subScreen/comn/appbar/custom_appbar.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        padding: EdgeInsets.all(10),
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppbar(
                fnBackBtncallBack: () => {GoRouter.of(context).pop()},
                fnUpdtBtncallBack: () => {},
                title: "카테고리",
                isNotification: true,
                isEditBtn: false,
                isAddTrackBtn : false,
              ),
              SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '추천',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 9,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/testImage4.png',
                          width: 90.w,
                          height: 30.h,
                          fit: BoxFit.cover, // 이미지가 영역을 꽉 채우도록 설정
                        ),
                        Container(
                          width: 90.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.lightBlueAccent.withOpacity(0.9),
                                // 하단은 어두운 색
                                Colors.transparent,
                                // 상단은 투명
                              ],
                              stops: [0, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '123123123',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'firstadmin',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white, // 테두리 색상
                                width: 3.0, // 테두리 두께
                              ),
                              shape: BoxShape.circle, // 원형으로 설정
                            ),
                            child: SvgPicture.asset(
                              'assets/images/play_circle.svg',
                              width: 4.5.w,
                              height: 4.5.h,
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '트렌드',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 7,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 5; i++) ...[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          // width: maxWidth * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Image.asset(
                                              'assets/images/testImage.png',
                                              width: 18.w,
                                              height: 9.h,
                                              fit: BoxFit
                                                  .cover, // 이미지가 영역을 꽉 채우도록 설정
                                            ),
                                            Container(
                                              width: 18.w,
                                              height: 9.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.lightBlueAccent
                                                        .withOpacity(0.9),
                                                    // 하단은 어두운 색
                                                    Colors.transparent,
                                                    // 상단은 투명
                                                  ],
                                                  stops: [0, 1.0],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    width: 60.w,
                                    padding: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.2, // 선의 두께
                                          color: Colors.grey, // 선의 색상
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '플레이리스트1',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              letterSpacing: -0.5
                                          ),
                                        ),
                                        Text(
                                          '오민규',
                                          style: TextStyle(   color: Colors.grey,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '54:34 / 63곡',
                                          style: TextStyle(   color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Image.asset(
                                              'assets/images/testImage.png',
                                              width: 18.w,
                                              height: 9.h,
                                              fit: BoxFit
                                                  .cover, // 이미지가 영역을 꽉 채우도록 설정
                                            ),
                                            Container(
                                              width: 18.w,
                                              height: 9.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.lightBlueAccent
                                                        .withOpacity(0.9),
                                                    // 하단은 어두운 색
                                                    Colors.transparent,
                                                    // 상단은 투명
                                                  ],
                                                  stops: [0, 1.0],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    width: 60.w,
                                    padding: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.2, // 선의 두께
                                          color: Colors.grey, // 선의 색상
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '플레이리스트1',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              letterSpacing: -0.5
                                          ),
                                        ),
                                        Text(
                                          '오민규',
                                          style: TextStyle(   color: Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '54:34 / 63곡',
                                          style: TextStyle(   color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Image.asset(
                                              'assets/images/testImage.png',
                                              width: 18.w,
                                              height: 9.h,
                                              fit: BoxFit
                                                  .cover, // 이미지가 영역을 꽉 채우도록 설정
                                            ),
                                            Container(
                                              width: 18.w,
                                              height: 9.h,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.lightBlueAccent
                                                        .withOpacity(0.9),
                                                    // 하단은 어두운 색
                                                    Colors.transparent,
                                                    // 상단은 투명
                                                  ],
                                                  stops: [0, 1.0],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Container(
                                    width: 60.w,
                                    padding: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.2, // 선의 두께
                                          color: Colors.grey, // 선의 색상
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '플레이리스트1',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              letterSpacing: -0.5
                                          ),
                                        ),
                                        Text(
                                          '오민규',
                                          style: TextStyle(   color: Colors.grey,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '54:34 / 63곡',
                                          style: TextStyle(   color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // 간격 추가
                    ],
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '플레이리스트',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '더보기',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Wrap(
                spacing: 24.0, // 아이템 간의 가로 간격
                runSpacing: 20.0, // 줄 간격
                alignment: WrapAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 4; i++) ...[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    'assets/images/testImage5.png',
                                    width: 40.w,
                                    height: 20.h,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Container(
                                  width: 40.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.9),
                                        // 하단은 어두운 색
                                        Colors.transparent,
                                        // 상단은 투명
                                      ],
                                      stops: [0, 1.0],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.asset(
                                      'assets/images/testImage5.png',
                                      width: 20.w,
                                      height: 10.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // SizedBox(height: 10),
                            Container(
                              width: 160,
                              child: Row(
                                children: [
                                  Text(
                                    '플레이리스트',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (true) ...[
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            Text(
                              'first_admin',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ],
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
