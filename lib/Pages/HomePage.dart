import 'package:CompanyDatabase/Pages/CreatePage.dart';
import 'package:CompanyDatabase/Pages/DeletePage.dart';
import 'package:CompanyDatabase/Pages/SearchPage.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.h, left: 30.w, right: 30.w, bottom: 30.h),
            child: Column(
              children: [
                Text(
                  'JSI \nEmployee Management',
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 35.sp,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // First Row
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreatePage(),
                              ),
                            );
                          },
                          child: Container(
                            width: 130.w,
                            height: 170.h,
                            decoration: BoxDecoration(
                              color: Color(0xffe0f2fc),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: fontColorBlack,
                                  size: 40.sp,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Create',
                                  style: TextStyle(
                                    color: fontColorBlack,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllEmployee()));
                          },
                          child: Container(
                            width: 130.w,
                            height: 170.h,
                            decoration: BoxDecoration(
                              color: Color(0xffe5e1fc),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.list,
                                  color: fontColorBlack,
                                  size: 40.sp,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: fontColorBlack,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 35.h), // Spacer between rows
                    // Second Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeleteEmployee()),
                            );
                          },
                          child: Container(
                            width: 130.w,
                            height: 170.h,
                            decoration: BoxDecoration(
                              color: Color(0xfffcf0e2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: fontColorBlack,
                                  size: 40.sp,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: fontColorBlack,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle 'Excel' container tap
                          },
                          child: Container(
                            width: 130.w,
                            height: 170.h,
                            decoration: BoxDecoration(
                              color: Color(0xfff5f4ef),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.table_chart_outlined,
                                  color: fontColorBlack,
                                  size: 40.sp,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Excel',
                                  style: TextStyle(
                                    color: fontColorBlack,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showModalBottomSheet(
      //         context: context, builder: (context) => addTaskScreen());
      //   },
      //   backgroundColor: Colors.lightBlueAccent,
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
