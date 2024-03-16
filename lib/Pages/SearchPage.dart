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
import 'package:google_fonts/google_fonts.dart';
import 'CreatePage.dart';

class AllEmployee extends StatefulWidget {
  @override
  AllEmployeeState createState() => AllEmployeeState();
}

class AllEmployeeState extends State<AllEmployee> {
  bool isLoading = false;
  List<int> data = [];
  TextEditingController searchController = TextEditingController();
  List<CommonFormModel> filteredEmployees = [];
  List<CommonFormModel> employees = [];
  int activeIndex = 0;

  void searchEmployees(String query) {
    // Implement your logic to filter employees based on the search query
    // Here, I'm using a simple case-insensitive contains check for demonstration

    filteredEmployees = employees
        .where((employee) =>
            employee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {});
    print("printing search result ${filteredEmployees.toString()}");
  }

  void getData() async {}

  void create() async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePage(),
      ),
    );
    if (result == 'submitted') {
      isLoading = true;
      getData();
    }
  }

  void delete() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeleteEmployee()),
    );
  }

  void edit(CommonFormModel commonFormModel) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeFormUpdate(
          employeeDetails: commonFormModel,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    activeIndex = 0;
    setState(() {});
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: fontColor),
        title: Text(
          "Employee Database",
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
          children: [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 320,
              child: TextField(
                controller: searchController,
                onChanged: (query) => searchEmployees(query),
                style: TextStyle(color: fontColor),
                decoration: InputDecoration(
                  hintText: "Search by name...",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (filteredEmployees.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Search Result",
                      style: TextStyle(
                        color: fontColorBlack,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ),
                  Container(
                    height: 200.h,
                    width: 340.w,
                    color: Colors.white,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredEmployees.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 100.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.black,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        filteredEmployees[index].photo?.path ??
                                            "",
                                    width: 50.w,
                                    height: 50.h,
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
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      filteredEmployees[index].category,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: fontColorBlack,
                                      ),
                                    ),
                                    Text(
                                      filteredEmployees[index].name,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: fontColorBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.all(8.0),
                        );
                      },
                    ),
                  ),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "All Employee",
                    style: TextStyle(
                      color: fontColorBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      fontFamily: fontFamily,
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
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontFamily: fontFamily,
                        ),
                      ));
                    }

                    log(snapshot.data.toString());

                    employees = snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.all(0),
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
                            ontap: () {
                              edit(employees[index]);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // bottomNavigationBar: YourBottomNavBar(),
    );
  }
}
