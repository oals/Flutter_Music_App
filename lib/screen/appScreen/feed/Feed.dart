import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/router/app_bottom_modal_router.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    
  });

  

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar :AppBar(
        backgroundColor: Color(0xff200f2e),
        title: Text(
          "sync",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              // 파일 선택기 띄우기
              AppBottomModalRouter.fnModalRouter(context,1);
            },
            child: SvgPicture.asset(
              'assets/images/upload.svg',
              color: Colors.grey[100],
              width: 30,
              height: 30,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color : Color(0xff200f2e),
        width: 100.w,
        height: 100.h,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 90.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2,color: Colors.grey)
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/testImage.png',),
                        Container(
                          width: 90.w,
                          height: 10.h,
                          padding: EdgeInsets.all(10),
                          color: Color(0xff200f2e),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Choosing the best drumsticks',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
                              Text('24-09-28',style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w700),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),



                  ],

                ),
              ),
              SizedBox(height: 40,),
              Container(
                width: 90.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2,color: Colors.grey)
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/testImage.png',),
                        Container(
                          width: 90.w,
                          height: 10.h,
                          padding: EdgeInsets.all(10),
                          color: Color(0xff200f2e),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Choosing the best drumsticks',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
                              Text('24-09-28',style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w700),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),



                  ],

                ),
              ),
              SizedBox(height: 40,),
              Container(
                width: 90.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2,color: Colors.grey)
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/testImage.png',),
                        Container(
                          width: 90.w,
                          height: 10.h,
                          padding: EdgeInsets.all(10),
                          color: Color(0xff200f2e),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Choosing the best drumsticks',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
                              Text('24-09-28',style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w700),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),



                  ],

                ),
              ),
              SizedBox(height: 40,),
              Container(
                width: 90.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2,color: Colors.grey)
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Image.asset('assets/images/testImage.png',),
                        Container(
                          width: 90.w,
                          height: 10.h,
                          padding: EdgeInsets.all(10),
                          color: Color(0xff200f2e),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Choosing the best drumsticks',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white),),
                              Text('24-09-28',style: TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w700),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),



                  ],

                ),
              ),

              SizedBox(height: 80,),
            ],
          ),
        ),
      ),
    );
  }
}
