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
        height: 180.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Container(
                width: 120.w,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.black,
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: fontColorBlack,
                      fontSize: 16.sp,
                      fontFamily: fontFamily,
                    ),
                  ),
                  Text(
                    service,
                    style: TextStyle(
                      color: fontColorBlack,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                  Text(
                    "₹ $amount",
                    style: TextStyle(
                      color: amount.startsWith('-') ? Colors.red : Colors.green,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: fontFamily,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.star,
                size: 13,
                color: Colors.white, // Set the base color of the icon
              ),
            ],
          ),
        ),
      ),
    );
  }
}
