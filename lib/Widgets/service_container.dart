// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:CompanyDatabase/utils/contants.dart';

class ServiceContainer extends StatelessWidget {
  final String text;
  final String service;
  final String amount;
  final String image;
  VoidCallback ontap;

  ServiceContainer({
    Key? key,
    required this.text,
    required this.service,
    required this.amount,
    required this.image,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Container(
                width: 90.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 36.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: fontColorBlack,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                  Text(
                    service,
                    style: TextStyle(
                      color: fontColorBlack,
                      fontSize: 14.sp,
                      fontFamily: fontFamily,
                    ),
                  ),
                  Text(
                    "₹ $amount",
                    style: TextStyle(
                      color: amount.startsWith('-') ? Colors.red : Colors.green,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
