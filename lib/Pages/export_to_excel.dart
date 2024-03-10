import 'dart:developer';
import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:CompanyDatabase/Models/excel_model.dart';
import 'package:CompanyDatabase/Pages/DeletePage.dart';
import 'package:CompanyDatabase/Pages/update_profile.dart';
import 'package:CompanyDatabase/Widgets/service_container.dart';
import 'package:CompanyDatabase/firebaseCURD/firebase_functions.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'CreatePage.dart';

class ExportToExcelEmployee extends StatefulWidget {
  @override
  ExportToExcelEmployeeState createState() => ExportToExcelEmployeeState();
}

class ExportToExcelEmployeeState extends State<ExportToExcelEmployee> {
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
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: fontColor),
        title: Text(
          "Employee Excel",
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
                            ontap: () {},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (employees.isNotEmpty) {
            setState(() {
              isLoading = true;
            });
            ExcelModel.EmployeeExcel(employees);
            setState(() {
              isLoading = false;
            });
          }
        },
        child: Icon(Icons.download),
        backgroundColor: themeColor,
      ),
      // Optionally use bottomNavigationBar: YourBottomNavBar(),
    );
  }
}
