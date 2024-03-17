import 'dart:developer';
import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:CompanyDatabase/Pages/DeletePage.dart';
import 'package:CompanyDatabase/Pages/employee_view.dart';
import 'package:CompanyDatabase/Pages/update_profile.dart';
import 'package:CompanyDatabase/Widgets/navbar.dart';
import 'package:CompanyDatabase/Widgets/service_container.dart';
import 'package:CompanyDatabase/firebaseCURD/firebase_functions.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CreatePage.dart';

class DeleteEmployee extends StatefulWidget {
  @override
  DeleteEmployeeState createState() => DeleteEmployeeState();
}

class DeleteEmployeeState extends State<DeleteEmployee> {
  bool isLoading = false;
  List<int> data = [];

  List<CommonFormModel> employees = [];
  int activeIndex = 0;

  void edit(CommonFormModel commonFormModel) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmployeeFormUpdate(
                  employeeDetails: commonFormModel,
                )));
  }

  String? _currentUser;
  void _fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser');
    });
    log(_currentUser.toString());
  }

  @override
  void initState() {
    super.initState();
    activeIndex = 0;
    setState(() {});
    _fetchCurrentUser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: fontColor),
        title: Text(
          "Delete Employee",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 23.sp,
            color: fontColor,
            decorationThickness: 5,
            fontFamily: fontFamily,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "All Employee",
                style: TextStyle(
                  color: fontColorBlack,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                ),
              ),
            ),
            StreamBuilder<List<CommonFormModel>>(
              stream: FirebaseService.getAllEmployeesStream(),
              builder:
                  (context, AsyncSnapshot<List<CommonFormModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  log(snapshot.error.toString());
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(
                    'No data available',
                    style: TextStyle(
                      color: fontColorBlack,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ));
                }

                log(snapshot.data.toString());

                employees = snapshot.data!;

                return ListView.builder(
                  itemCount: employees.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ServiceContainer(
                        text: employees[index].name,
                        service: employees[index].category,
                        amount: employees[index].amount,
                        image: employees[index].photo?.path ?? "",
                        ontap: () async {
                          // Show confirmation dialog
                          log(_currentUser.toString());
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
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            final confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                      'Are you sure you want to delete this employee?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            // If deletion is confirmed
                            if (confirmDelete == true) {
                              log(employees[index].uid.toString());
                              await FirebaseService.deleteEmployee(
                                  employees[index].uid.toString());

                              // Optionally, refresh the list of employees or show a success message
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Employee deleted'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      //  bottomNavigationBar: YourBottomNavBar()
    );
  }
}
