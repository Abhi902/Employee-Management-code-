import 'dart:developer';
import 'dart:io';

import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:CompanyDatabase/Models/ServerUtil.dart';
import 'package:CompanyDatabase/Provider/employee_provider.dart';
import 'package:CompanyDatabase/Widgets/DropDowns.dart';
import 'package:CompanyDatabase/Widgets/FormFields.dart';
import 'package:CompanyDatabase/firebaseCURD/firebase_functions.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'CommonForm.dart';

class EmployeeForm extends StatefulWidget {
  EmployeeForm();

  @override
  EmployeeFormState createState() => EmployeeFormState();
}

class EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _referenceController = TextEditingController();
  TextEditingController _attendanceController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _advanceController = TextEditingController();
  TextEditingController _kharchaController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  Future<void> indicatorToggle() async {
    _isLoading = !_isLoading;
    setState(() {});
  }

  TextEditingController _autoRentController = TextEditingController();
  XFile? _imageFile;
  String? selectedCategory;

  Future<void> _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile;

    try {
      pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
    } catch (e) {
      print('Error while picking an image: $e');
    }

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
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
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
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
                          CircleAvatar(
                            radius: 80, // Adjust the radius as needed
                            backgroundColor:
                                Colors.white, // Set a transparent background
                            backgroundImage: _imageFile != null
                                ? FileImage(File(_imageFile!.path))
                                : null,
                            child: _imageFile == null
                                ? Icon(Icons.person,
                                    size: 100.sp,
                                    color: Colors
                                        .grey) // Display an icon when no image is selected
                                : null,
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.sp),
                    ElevatedButton(
                      onPressed: _takePicture,
                      child: Text('Take Picture',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: fontColor,
                            fontFamily: fontFamily,
                          )),
                    ),
                    SizedBox(height: 20.sp),
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
                      height: 20.sp,
                    ),
                    Row(
                      children: [
                        Text(
                          'Category:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: Colors.grey[600],
                            fontFamily: fontFamily,
                          ),
                        ),
                        SizedBox(width: 20.sp),
                        DropdownButton<String>(
                          value: selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                          items: <String>[
                            'Mistry',
                            'Helper',
                            'Cutting',
                            'Polish Mister',
                            'Polish Helper'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
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
                    SizedBox(height: 20.sp),
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
                        TextFormField(
                          controller: _rateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _amountController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Rate',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _amountController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
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
                              return 'Please enter a rate';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (_advanceController.text.isNotEmpty &&
                                _amountController.text.isNotEmpty &&
                                _rateController.text.isNotEmpty &&
                                _kharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              _amountController.text = ((double.parse(
                                              _attendanceController.text) *
                                          double.parse(_rateController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _kharchaController.text) +
                                          double.parse(
                                              _autoRentController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
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
                        TextFormField(
                          controller: _attendanceController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                          ],
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Attendance',
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
                                _kharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              _amountController.text = ((double.parse(
                                              _attendanceController.text) *
                                          double.parse(_rateController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _kharchaController.text) +
                                          double.parse(
                                              _autoRentController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter attendance';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
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
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _amountController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Amount',
                            enabled: false,
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _amountController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
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
                    SizedBox(height: 20.sp),
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
                        TextFormField(
                          controller: _advanceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _amountController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Advance',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _advanceController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
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
                              return 'Please enter an advance';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (_advanceController.text.isNotEmpty &&
                                _amountController.text.isNotEmpty &&
                                _rateController.text.isNotEmpty &&
                                _kharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              _amountController.text = ((double.parse(
                                              _attendanceController.text) *
                                          double.parse(_rateController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _kharchaController.text) +
                                          double.parse(
                                              _autoRentController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kharcha",
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
                          controller: _kharchaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _amountController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Kharcha',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _kharchaController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
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
                              _amountController.text = ((double.parse(
                                              _attendanceController.text) *
                                          double.parse(_rateController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _kharchaController.text) +
                                          double.parse(
                                              _autoRentController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
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
                        TextFormField(
                          controller: _autoRentController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.sp,
                            fontFamily: fontFamily,
                            color: _amountController.text.startsWith('-')
                                ? Colors.red
                                : Colors.green,
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Auto Rent',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: hintColor,
                              fontFamily: fontFamily,
                            ),
                            prefix: Text(
                              '₹',
                              style: TextStyle(
                                color: _autoRentController.text.startsWith('-')
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 18.sp,
                              ),
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
                              return 'Please enter a balance';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (_advanceController.text.isNotEmpty &&
                                _amountController.text.isNotEmpty &&
                                _rateController.text.isNotEmpty &&
                                _kharchaController.text.isNotEmpty &&
                                _autoRentController.text.isNotEmpty) {
                              _amountController.text = ((double.parse(
                                              _attendanceController.text) *
                                          double.parse(_rateController.text)) -
                                      (double.parse(_advanceController.text) +
                                          double.parse(
                                              _kharchaController.text) +
                                          double.parse(
                                              _autoRentController.text)))
                                  .toString();
                            } else {
                              _amountController.text = "0";
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String name = _nameController.text;
                          XFile? photo = _imageFile;
                          String category = selectedCategory as String;
                          String reference = _referenceController.text;
                          String rate = _rateController.text;
                          String attendance = _attendanceController.text;
                          String amount = _amountController.text;
                          String advance = _advanceController.text;
                          String kharcha = _kharchaController.text;
                          String autoRent = _autoRentController.text;

                          CommonFormModel newObject = CommonFormModel(
                            name: name,
                            photo: photo,
                            category: category,
                            reference: reference,
                            rate: rate,
                            attendance: attendance,
                            amount: amount,
                            advance: advance,
                            kharcha: kharcha,
                            autoRent: autoRent,
                            createdAt: DateTime.now(),
                          );
                          indicatorToggle();
                          FirebaseService firebaseService = FirebaseService();

                          await firebaseService.addEmployee(newObject);
                          indicatorToggle();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Employee added to the directory'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: fontColor,
                          fontFamily: fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
