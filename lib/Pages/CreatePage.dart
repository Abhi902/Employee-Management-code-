import 'package:CompanyDatabase/Widgets/EmployeeForm.dart';
import 'package:CompanyDatabase/Widgets/navbar.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CreatePage extends StatelessWidget {
  CreatePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: themeColor,
        iconTheme: IconThemeData(color: fontColor),
        elevation: 0.0,
        title: Text(
          "Add Employee",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 23.sp,
            color: fontColor,
            fontFamily: fontFamily,
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xffedebe6)
                  ], // Replace with your desired colors
                ),
              ),
            ),
            EmployeeForm(),
          ],
        ),
      ),
      // bottomNavigationBar: YourBottomNavBar(),
    );
  }
}
