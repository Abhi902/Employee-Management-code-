import 'package:CompanyDatabase/Pages/CreatePage.dart';
import 'package:CompanyDatabase/Pages/DeletePage.dart';
import 'package:CompanyDatabase/Pages/SearchPage.dart';
import 'package:CompanyDatabase/Pages/export_to_excel.dart';
import 'package:CompanyDatabase/firebaseCURD/firebase_functions.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _currentUser;
  List<Map<String, dynamic>> userIdentity = [];

  void _fetchCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser');
    });
    userIdentity = await FirebaseService.fetchAllUsers();

    print(userIdentity.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCurrentUser();
  }

  Widget build(BuildContext context) {
    final List<String> names = [
      'Pankaj',
      'Shivkumar',
      'Deep',
      'Umesh',
      'Krishanpal'
    ];

    return Scaffold(
      backgroundColor: themeColor,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Profile',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30.sp,
                    fontFamily: fontFamily,
                    color: fontColor),
              ),
              decoration: BoxDecoration(
                color: themeColor,
              ),
            ),
            ListTile(
              leading: Text(
                'Pankaj',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20.sp,
                  fontFamily: fontFamily,
                  color:
                      _currentUser == 'Pankaj' ? Colors.blue : fontColorBlack,
                ),
              ),
              tileColor: _currentUser == 'Pankaj'
                  ? Colors.lightBlueAccent
                  : Colors.transparent,
              onTap: () async {
                // Close the drawer
                final String? password = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PasswordInputDialog();
                  },
                );

                if (password != null &&
                    password.isNotEmpty &&
                    password == userIdentity[0]["Pankaj"]) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('currentUser', 'Pankaj');

                  setState(() {
                    _currentUser = 'Pankaj';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Verified'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Not Verified ! Enter Again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Text(
                'Shivkumar',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                    fontFamily: fontFamily,
                    color: fontColorBlack),
              ),
              tileColor: _currentUser == 'Shivkumar'
                  ? Colors.lightBlueAccent
                  : Colors.transparent,
              onTap: () async {
                // Close the drawer
                final String? password = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PasswordInputDialog();
                  },
                );

                if (password != null &&
                    password.isNotEmpty &&
                    password == userIdentity[0]["Shivkumar"]) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('currentUser', 'Shivkumar');

                  setState(() {
                    _currentUser = 'Shivkumar';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Verified'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Not Verified ! Enter Again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Deep',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                    fontFamily: fontFamily,
                    color: fontColorBlack),
              ),
              tileColor: _currentUser == 'Deep'
                  ? Colors.lightBlueAccent
                  : Colors.transparent,
              onTap: () async {
                // Close the drawer
                final String? password = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PasswordInputDialog();
                  },
                );

                if (password != null &&
                    password.isNotEmpty &&
                    password == userIdentity[0]["Deep"]) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('currentUser', 'Deep');

                  setState(() {
                    _currentUser = 'Deep';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Verified'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Not Verified ! Enter Again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Umesh',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                    fontFamily: fontFamily,
                    color: fontColorBlack),
              ),
              tileColor: _currentUser == 'Umesh'
                  ? Colors.lightBlueAccent
                  : Colors.transparent,
              onTap: () async {
                // Close the drawer
                final String? password = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PasswordInputDialog();
                  },
                );

                if (password != null &&
                    password.isNotEmpty &&
                    password == userIdentity[0]["Umesh"]) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('currentUser', 'Umesh');

                  setState(() {
                    _currentUser = 'Umesh';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Verified'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Not Verified ! Enter Again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                'Krishanpal',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                    fontFamily: fontFamily,
                    color: fontColorBlack),
              ),
              tileColor: _currentUser == 'Krishanpal'
                  ? Colors.lightBlueAccent
                  : Colors.transparent,
              onTap: () async {
                // Close the drawer
                final String? password = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PasswordInputDialog();
                  },
                );

                if (password != null &&
                    password.isNotEmpty &&
                    password == userIdentity[0]["Krishanpal"]) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('currentUser', 'Krishanpal');

                  setState(() {
                    _currentUser = 'Krishanpal';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Verified'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password Not Verified ! Enter Again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }

                Navigator.pop(context);
              },
            ),
            Divider(),
            // Add more ListTiles for other names if necessary
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: 10.h, left: 30.w, right: 10.w, bottom: 30.h),
                  child: Column(
                    children: [
                      Text(
                        'JSI \nEmployee \nManagement',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: 35.sp,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 50, // Adjust the radius to your preference
                  backgroundColor: Colors
                      .transparent, // Assuming your background color is already set
                  backgroundImage: AssetImage("assets/logo.jpeg"),
                ),
              ],
            ),
            Container(
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
                            width: 140.w,
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
                                  'Add \nEmployee',
                                  textAlign: TextAlign.center,
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
                            width: 140.w,
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
                                  'View \nEmployees',
                                  textAlign: TextAlign.center,
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
                            width: 140.w,
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
                                  'Remove \nEmployees',
                                  textAlign: TextAlign.center,
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
                                  builder: (context) =>
                                      ExportToExcelEmployee()),
                            );
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
                                  'Export To Excel',
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Confirm Deletion',
                                  style: TextStyle(
                                    color: fontColorBlack,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to Update all employee data?',
                                  style: TextStyle(
                                    color: fontColorBlack,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: fontColorBlack,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        color: fontColorBlack,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          // If deletion is confirmed
                          if (confirmDelete == true) {
                          } else {}
                        },
                        child: Container(
                          height: 120.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.0),
                            gradient: LinearGradient(
                              colors: [Color(0xffe5e1fc), Color(0xffe5e1fc)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10.h),
                                Icon(
                                  Icons.update,
                                  color: fontColorBlack,
                                  size: 40.sp,
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Update All Entries',
                                  style: TextStyle(
                                      color: fontColorBlack,
                                      fontSize: 22.sp,
                                      fontFamily: fontFamily,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class PasswordInputDialog extends StatefulWidget {
  @override
  _PasswordInputDialogState createState() => _PasswordInputDialogState();
}

class _PasswordInputDialogState extends State<PasswordInputDialog> {
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Password'),
      content: TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String password = _passwordController.text;
            Navigator.pop(context, password);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
