// import 'dart:developer';
// import 'dart:io';

// import 'package:CompanyDatabase/Models/Employee.dart';
// import 'package:CompanyDatabase/Models/ServerUtil.dart';
// import 'package:CompanyDatabase/Provider/employee_provider.dart';
// import 'package:CompanyDatabase/Widgets/DropDowns.dart';
// import 'package:CompanyDatabase/Widgets/FormFields.dart';
// import 'package:CompanyDatabase/firebaseCURD/firebase_functions.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class DetailsView extends StatefulWidget {
//   final CommonFormModel employeeDetails;
//   DetailsView({required this.employeeDetails});

//   @override
//   DetailsViewState createState() => DetailsViewState();
// }

// class DetailsViewState extends State<DetailsView> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _referenceController = TextEditingController();
//   TextEditingController _attendanceController = TextEditingController();
//   TextEditingController _rateController = TextEditingController();
//   TextEditingController _advanceController = TextEditingController();
//   TextEditingController _kharchaController = TextEditingController();
//   TextEditingController _amountController = TextEditingController();
//   TextEditingController _selectedCategory = TextEditingController();
//   TextEditingController _autoRentController = TextEditingController();
//   String? _imageFile;
//   String? selectedCategory;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _referenceController.dispose();
//     _attendanceController.dispose();
//     _amountController.dispose();
//     _rateController.dispose();
//     _advanceController.dispose();
//     _kharchaController.dispose();
//     _autoRentController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _nameController.text = widget.employeeDetails.name;
//     _referenceController.text = widget.employeeDetails.reference;
//     _attendanceController.text = widget.employeeDetails.attendance;
//     _rateController.text = widget.employeeDetails.rate;
//     _advanceController.text = widget.employeeDetails.advance;
//     _kharchaController.text = widget.employeeDetails.kharcha;
//     _amountController.text = widget.employeeDetails.amount;
//     _autoRentController.text = widget.employeeDetails.autoRent;
//     _selectedCategory.text = widget.employeeDetails.category;
//     _imageFile = widget.employeeDetails.photo?.path;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff434cab),
//         elevation: 0.0,
//         title: Text(
//           "Updated Employee",
//           textAlign: TextAlign.left,
//           style: GoogleFonts.josefinSans(
//               textStyle: TextStyle(
//                   fontSize: 23, color: Colors.white, decorationThickness: 5)),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               _imageFile != null
//                   ? Padding(
//                       padding: const EdgeInsets.all(18.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Photo',
//                             style: GoogleFonts.josefinSans(
//                               textStyle: TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold,
//                                 decorationThickness: 10,
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20.h,
//                           ),
//                           Container(
//                             width: 300.w,
//                             height: 300.h,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(26.0),
//                             ),
//                             child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(15.0),
//                                 child: CachedNetworkImage(
//                                   imageUrl: _imageFile.toString(),
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                   placeholder: (context, url) => Icon(
//                                     Icons.person,
//                                     size: 50,
//                                     color: Colors.black,
//                                   ),
//                                   errorWidget: (context, url, error) => Icon(
//                                     Icons.error,
//                                     size: 50,
//                                     color: Colors.black,
//                                   ),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                     )
//                   : Container(),
//               SizedBox(height: 20),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _nameController,
//                 enabled: false,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   hintText: "Name",
//                   labelText: 'Name',
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   labelStyle: TextStyle(
//                       fontWeight: FontWeight.w900,
//                       color: Colors.black,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextFormField(
//                 controller: _selectedCategory,
//                 enabled: false,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   hintText: "Category:",
//                   labelText: 'Category:',
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   labelStyle: TextStyle(
//                       fontWeight: FontWeight.w900,
//                       color: Colors.black,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _referenceController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   hintText: 'Reference',
//                   labelText: 'Reference',
//                   labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a Reference';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _rateController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   hintText: 'Rate',
//                   labelText: 'Rate',
//                   labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a rate';
//                   }
//                   // Add additional validation if required
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _attendanceController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   hintText: 'Attendance',
//                   labelText: 'Attendance',
//                   labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter attendance';
//                   }
//                   // Add additional validation if required
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _amountController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   hintText: 'Amount',
//                   labelText: 'Amount',
//                   labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a Amount';
//                   }
//                   // Add additional validation if required
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _advanceController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   hintText: 'Advance',
//                   labelText: 'Advance',
//                   labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an advance';
//                   }
//                   // Add additional validation if required
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _kharchaController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   hintText: 'Kharcha',
//                   labelText: 'Kharcha',
//                   labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a Kharcha';
//                   }
//                   // Add additional validation if required
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _autoRentController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 enabled: false,
//                 decoration: InputDecoration(
//                   disabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   floatingLabelBehavior: FloatingLabelBehavior.always,
//                   hintText: 'Auto Rent',
//                   labelText: 'Auto Rent',
//                   labelStyle: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w900,
//                       fontSize: 18 // Set the fontWeight to 300
//                       ),
//                   border: OutlineInputBorder(
//                     // Use OutlineInputBorder for a complete box
//                     borderSide: BorderSide(
//                       color: Colors.black, // Define the border color
//                       width: 2.0, // Set the border width
//                     ),
//                     borderRadius:
//                         BorderRadius.circular(10.0), // Set border radius
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a balance';
//                   }
//                   // Add additional validation if required
//                   return null;
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text('Update'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// //   Color(0xffedebe6),