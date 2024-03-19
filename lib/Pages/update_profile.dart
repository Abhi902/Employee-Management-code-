import 'dart:developer';
import 'dart:io';

import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:CompanyDatabase/Models/ServerUtil.dart';
import 'package:CompanyDatabase/Provider/employee_provider.dart';
import 'package:CompanyDatabase/Widgets/DropDowns.dart';
import 'package:CompanyDatabase/Widgets/FormFields.dart';
import 'package:CompanyDatabase/firebaseCURD/firebase_functions.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeFormUpdate extends StatefulWidget {
  final CommonFormModel employeeDetails;
  EmployeeFormUpdate({required this.employeeDetails});

  @override
  EmployeeFormUpdateState createState() => EmployeeFormUpdateState();
}

class EmployeeFormUpdateState extends State<EmployeeFormUpdate> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _attendanceController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _advanceController = TextEditingController();
  TextEditingController _kharchaController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _selectedCategory = TextEditingController();
  TextEditingController _autoRentController = TextEditingController();
  TextEditingController _managerController = TextEditingController();
  TextEditingController _totalKharchaController = TextEditingController();

  String? _imageFile;
  List<String> kharchaUpdate = [];

  bool _isAdvanceEditing = false;
  bool _isKharchaEditing = false;
  bool _isAutoRentEditing = false;
  bool _isRateEditing = false;
  bool _isAttendanceEditing = false;

  String formatDateTime(DateTime dateTime) {
    // Format DateTime object into desired format
    String formattedDateTime =
        DateFormat('MMMM d, yyyy - hh:mm:ss a').format(dateTime);

    return formattedDateTime;
  }

  String? _currentUser;

  void _fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _referenceController.dispose();
    _attendanceController.dispose();
    _amountController.dispose();
    _rateController.dispose();
    _advanceController.dispose();
    _kharchaController.dispose();
    _autoRentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.employeeDetails.name;
    _referenceController.text = widget.employeeDetails.reference;
    _attendanceController.text = widget.employeeDetails.attendance;
    _rateController.text = widget.employeeDetails.rate;
    _advanceController.text = widget.employeeDetails.advance;
    _totalKharchaController.text = widget.employeeDetails.kharcha;
    _amountController.text = widget.employeeDetails.amount;
    _autoRentController.text = widget.employeeDetails.autoRent;
    _selectedCategory.text = widget.employeeDetails.category;
    _imageFile = widget.employeeDetails.photo?.path;

    _managerController.text =
        widget.employeeDetails.lastUpdatedPerson as String;
    setState(() {});
    _fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        iconTheme: IconThemeData(color: fontColor),
        elevation: 0.0,
        title: Text(
          "Updated Employee",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 23.sp,
            color: fontColor,
            decorationThickness: 5,
            fontFamily: fontFamily,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 20.w, right: 20.w, bottom: 18.h, top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Photo',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: fontColorBlack,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Container(
                      width: 180.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1000.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000.0),
                          child: CachedNetworkImage(
                            imageUrl: _imageFile.toString(),
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
                          )),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    controller: _nameController,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: hintColor,
                        fontFamily: fontFamily,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: borderColorTextField,
                          width: 2.0.w,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Updated by:",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    controller: _managerController,
                    enabled: false,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Last Updated by',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: hintColor,
                        fontFamily: fontFamily,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18.sp,
                        color: fontColor,
                        fontFamily: fontFamily,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: fontColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    controller: _selectedCategory,
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: "Category",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: hintColor,
                        fontFamily: fontFamily,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: borderColorTextField,
                          width: 2.0.w,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reference",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    controller: _referenceController,
                    enabled: false,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Reference',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: hintColor,
                        fontFamily: fontFamily,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18.sp,
                        color: fontColor,
                        fontFamily: fontFamily,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: fontColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Reference';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rate",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: TextFormField(
                          enabled: _isRateEditing,
                          controller: _rateController,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _rateController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Rate',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.sp,
                              color: fontColor,
                              fontFamily: fontFamily,
                            ),
                            // suffixText: formatDateTime(widget
                            //     .employeeDetails.lastUpdateRate as DateTime),
                            // suffixStyle: TextStyle(fontSize: 10),

                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: fontColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _rateController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (_advanceController.text.isNotEmpty &&
                                _amountController.text.isNotEmpty &&
                                _rateController.text.isNotEmpty &&
                                _totalKharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              _amountController.text = ((double.parse(
                                                  _attendanceController.text) *
                                              double.parse(
                                                  _rateController.text) +
                                          double.parse(
                                              _autoRentController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _totalKharchaController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a rate';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: fontColorBlack,
                        ),
                        onTap: () {
                          setState(() {
                            _isRateEditing = !_isRateEditing;
                          });
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      TapTooltip(
                        message: widget.employeeDetails.lastUpdateRate != null
                            ? "${_managerController.text} , ${formatDateTime(widget.employeeDetails.lastUpdateRate!)}"
                            : 'Never Updated',
                        child: Icon(Icons.info_outline, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attendance",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: TextFormField(
                          enabled: _isAttendanceEditing,
                          controller: _attendanceController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: Colors.grey,
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Attendence',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.sp,
                              color: fontColor,
                              fontFamily: fontFamily,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: fontColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Attendance';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            log("working");
                            log(_advanceController.text.isNotEmpty.toString());
                            log(_amountController.text.isNotEmpty.toString());
                            log(_rateController.text.isNotEmpty.toString());
                            log(_kharchaController.text.isNotEmpty.toString());
                            log(_autoRentController.text.isNotEmpty.toString());

                            if (_advanceController.text.isNotEmpty &&
                                _amountController.text.isNotEmpty &&
                                _rateController.text.isNotEmpty &&
                                _totalKharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              log("i am inside");
                              _amountController.text = ((double.parse(
                                                  _attendanceController.text) *
                                              double.parse(
                                                  _rateController.text) +
                                          double.parse(
                                              _autoRentController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _totalKharchaController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: fontColorBlack,
                        ),
                        onTap: () {
                          setState(() {
                            _isAttendanceEditing = !_isAttendanceEditing;
                          });
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      TapTooltip(
                        message: widget.employeeDetails.lastUpdateAttendance !=
                                null
                            ? "${_managerController.text} , ${formatDateTime(widget.employeeDetails.lastUpdateAttendance!)}"
                            : 'Never Updated',
                        child: Icon(Icons.info_outline, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: _amountController,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                      fontFamily: fontFamily,
                      color: _amountController.text.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      prefix: Text(
                        '₹',
                        style: TextStyle(
                          color: _amountController.text.startsWith('-')
                              ? Colors.red
                              : Colors.green,
                          fontSize: 18.sp,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Amount',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: hintColor,
                        fontFamily: fontFamily,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18.sp,
                        color: fontColor,
                        fontFamily: fontFamily,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: fontColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Advance",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: TextFormField(
                          enabled: _isAdvanceEditing,
                          controller: _advanceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _advanceController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _advanceController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Rate',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.sp,
                              color: fontColor,
                              fontFamily: fontFamily,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: fontColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (value) {
                            if (_advanceController.text.isNotEmpty &&
                                _amountController.text.isNotEmpty &&
                                _rateController.text.isNotEmpty &&
                                _totalKharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              _amountController.text = ((double.parse(
                                                  _attendanceController.text) *
                                              double.parse(
                                                  _rateController.text) +
                                          double.parse(
                                              _autoRentController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _totalKharchaController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Advance';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: fontColorBlack,
                        ),
                        onTap: () {
                          setState(() {
                            _isAdvanceEditing = !_isAdvanceEditing;
                          });
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      TapTooltip(
                        message: widget.employeeDetails.lastUpdateAdvance !=
                                null
                            ? "${_managerController.text} , ${formatDateTime(widget.employeeDetails.lastUpdateAdvance!)}"
                            : 'Never Updated',
                        child: Icon(Icons.info_outline, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Auto Rent",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: TextFormField(
                          enabled: _isAutoRentEditing,
                          controller: _autoRentController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _autoRentController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _autoRentController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Auto Rent',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.sp,
                              color: fontColor,
                              fontFamily: fontFamily,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: fontColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (value) {
                            if (_advanceController.text.isNotEmpty &&
                                _amountController.text.isNotEmpty &&
                                _rateController.text.isNotEmpty &&
                                _totalKharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              _amountController.text = ((double.parse(
                                                  _attendanceController.text) *
                                              double.parse(
                                                  _rateController.text) +
                                          double.parse(
                                              _autoRentController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _totalKharchaController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Kharcha';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: fontColorBlack,
                        ),
                        onTap: () {
                          setState(() {
                            _isAutoRentEditing = !_isAutoRentEditing;
                          });
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      TapTooltip(
                        message: widget.employeeDetails.lastUpdateAutoRent !=
                                null
                            ? "${_managerController.text} , ${formatDateTime(widget.employeeDetails.lastUpdateAutoRent!)}"
                            : 'Never Updated',
                        child: Icon(Icons.info_outline, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Kharcha",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150.w,
                        height: 85.h,
                        child: TextFormField(
                          controller: _kharchaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _kharchaController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _kharchaController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Kharcha',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18.sp,
                              color: fontColor,
                              fontFamily: fontFamily,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: borderColorTextField,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: borderColorTextField,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: borderColorTextField,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        child: Container(
                          width: 40.w, // Adjust the size as needed
                          height: 40.h, // Adjust the size as needed
                          decoration: BoxDecoration(
                            color:
                                themeColor, // Background color of the container
                            shape:
                                BoxShape.circle, // Makes the container circular
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors
                                  .white, // Assuming fontColorBlack is defined elsewhere as Colors.black
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _totalKharchaController.text =
                                (double.parse(_totalKharchaController.text) +
                                        double.parse(
                                            _kharchaController.text ?? "0"))
                                    .toString();

                            kharchaUpdate.add(_kharchaController.text);
                            _kharchaController.text = '0';

                            _amountController.text = ((double.parse(
                                                _attendanceController.text) *
                                            double.parse(_rateController.text) +
                                        double.parse(
                                            _autoRentController.text)) -
                                    (double.parse(_advanceController.text) +
                                        double.parse(
                                            _totalKharchaController.text)))
                                .toString();
                          });

                          log(_kharchaController.text);
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      TapTooltip(
                        message: widget.employeeDetails.lastUpdateKharcha !=
                                null
                            ? "${_managerController.text} , ${formatDateTime(widget.employeeDetails.lastUpdateKharcha!)}"
                            : 'Never Updated',
                        child: Icon(Icons.info_outline, size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Kharcha",
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14.sp,
                      color: Color.fromRGBO(106, 107, 112, 1),
                      fontFamily: fontFamily,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  TextFormField(
                    enabled: false,
                    controller: _totalKharchaController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18.sp,
                      fontFamily: fontFamily,
                      color: _kharchaController.text.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                    ),
                    decoration: InputDecoration(
                      prefix: Text(
                        '₹',
                        style: TextStyle(
                          color: _kharchaController.text.startsWith('-')
                              ? Colors.red
                              : Colors.green,
                          fontSize: 18.sp,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Total Kharcha',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: hintColor,
                        fontFamily: fontFamily,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18.sp,
                        color: fontColor,
                        fontFamily: fontFamily,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: fontColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Kharcha';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (_advanceController.text.isNotEmpty &&
                          _amountController.text.isNotEmpty &&
                          _rateController.text.isNotEmpty &&
                          _kharchaController.text.isNotEmpty &&
                          _autoRentController.text.isNotEmpty) {
                        _amountController
                            .text = ((double.parse(_attendanceController.text) *
                                        double.parse(_rateController.text) +
                                    double.parse(_autoRentController.text)) -
                                (double.parse(_advanceController.text) +
                                    double.parse(_kharchaController.text)))
                            .toString();
                      } else {
                        _amountController.text = "0";
                      }
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_currentUser == null) {
                    // Show a dialog if no user is selected
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text("Empty User"),
                          content: Text(
                              "No User Selected ! Select a user from profile"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    log('working');
                    if (_formKey.currentState?.validate() ?? false) {
                      //Call the update function with the edited values

                        if (_advanceController.text.isNotEmpty &&
                          _amountController.text.isNotEmpty &&
                          _rateController.text.isNotEmpty &&
                          _totalKharchaController.text.isNotEmpty &&
                          _autoRentController.text.isNotEmpty) {
                        _amountController
                            .text = ((double.parse(_attendanceController.text) *
                                        double.parse(_rateController.text) +
                                    double.parse(_autoRentController.text)) -
                                (double.parse(_advanceController.text) +
                                    double.parse(_totalKharchaController.text)))
                            .toString();
                      } else {
                        _amountController.text = "0";
                      }

                      if (widget.employeeDetails.manager != null &&
                          widget.employeeDetails.manager!
                              .containsKey(_currentUser)) {
                        widget.employeeDetails.manager![_currentUser]!
                            .addAll(kharchaUpdate);
                      } else {
                        widget.employeeDetails
                            .manager?[_currentUser as String] = kharchaUpdate;
                      }

                      print(widget.employeeDetails.manager.toString());

                      await FirebaseService.updateEmployee(
                          documentId: widget.employeeDetails.uid!,
                          advance: _advanceController.text !=
                                  widget.employeeDetails.advance
                              ? _advanceController.text
                              : null,
                          kharcha: _totalKharchaController.text !=
                                  widget.employeeDetails.kharcha
                              ? _totalKharchaController.text
                              : null,
                          autoRent: _autoRentController.text !=
                                  widget.employeeDetails.autoRent
                              ? _autoRentController.text
                              : null,
                          rate: _rateController.text !=
                                  widget.employeeDetails.rate
                              ? _rateController.text
                              : null,
                          amount: _amountController.text !=
                                  widget.employeeDetails.amount
                              ? _amountController.text
                              : null,
                          attendance: _attendanceController.text !=
                                  widget.employeeDetails.attendance
                              ? _attendanceController.text
                              : null,
                          lastUpdatedPerson: _currentUser,
                          managerMap: widget.employeeDetails.manager,
                          presentEmployee: widget.employeeDetails);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Updated Sucessfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: fontColor,
                    decorationThickness: 5,
                    fontFamily: fontFamily,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      themeColor), // Set your desired color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//   Color(0xffedebe6),

class TapTooltip extends StatefulWidget {
  final String message;
  final Widget child;

  const TapTooltip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);

  @override
  _TapTooltipState createState() => _TapTooltipState();
}

class _TapTooltipState extends State<TapTooltip> {
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final dynamic tooltip = _tooltipKey.currentState;
        tooltip?.ensureTooltipVisible();
      },
      child: Tooltip(
        key: _tooltipKey,
        message: widget.message,
        child: widget.child,
      ),
    );
  }
}
