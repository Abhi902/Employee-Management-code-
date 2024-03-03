import 'dart:developer';
import 'dart:io';

import 'package:CompanyDatabase/Models/Employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static Future<void> deleteEmployee(String documentId) async {
    log(documentId);
    try {
      await FirebaseDatabase.instance
          .ref()
          .child('EmployeeData')
          .child(documentId)
          .remove();
    } catch (e) {
      print('Error deleting employee: $e');
    }
  }

  static Stream<List<CommonFormModel>> getAllEmployeesStream() {
    DatabaseReference employeeDataReference =
        FirebaseDatabase.instance.ref().child('EmployeeData');

    return employeeDataReference.onValue.map(
      (event) {
        final employees = <CommonFormModel>[];

        if (event.snapshot.value != null) {
          Map<String, dynamic>? employeesData =
              (event.snapshot.value as Map<Object?, Object?>)
                  .cast<String, dynamic>();

          print(employeesData);

          employeesData.forEach((key, value) {
            // Assuming 'Monthly' is another Map inside each employee
            Map<String, dynamic>? monthlyData =
                (value['Monthly'] as Map<Object?, Object?>)
                    ?.cast<String, dynamic>();

            if (monthlyData != null) {
              // Get the keys (months) of monthly entries
              List<String> entryMonths =
                  monthlyData.keys.cast<String>().toList();

              // Sort the keys (months) in descending order
              entryMonths.sort((a, b) => b.compareTo(a));

              // Fetch the data for the current running month
              String currentMonth = DateFormat('MMMM').format(DateTime.now());
              if (entryMonths.isNotEmpty && entryMonths.first == currentMonth) {
                CommonFormModel employee = CommonFormModel.fromJson(
                  Map<String, dynamic>.from(monthlyData[currentMonth]),
                );
                employee.uid = key;
                print('Employee UID: ${employee.uid}');
                employees.add(employee);
              } else {
                CommonFormModel employee = CommonFormModel.fromJson(
                  Map<String, dynamic>.from(monthlyData[entryMonths.first]),
                );
                employee.uid = key;
                print('Employee UID: ${employee.uid}');
                employees.add(employee);
              }
            }
          });
        }

        return employees;
      },
    );
  }

  // static Stream<List<CommonFormModel>> getAllEmployeesStream() {
  //   DatabaseReference employeeDataReference =
  //       FirebaseDatabase.instance.ref().child('EmployeeData');

  //   return employeeDataReference.onValue.map(
  //     (event) {
  //       final employees = <CommonFormModel>[];

  //       if (event.snapshot.value != null) {
  //         // Explicitly cast to Map<String, dynamic>
  //         Map<String, dynamic>? employeesData =
  //             (event.snapshot.value as Map<Object?, Object?>)
  //                 .cast<String, dynamic>();

  //         employeesData.forEach((key, value) {
  //           CommonFormModel employee = CommonFormModel.fromJson(
  //             Map<String, dynamic>.from(value),
  //           );
  //           employees.add(employee);
  //         });
  //       }

  //       return employees;
  //     },
  //   );
  // }

  Future<bool> addEmployee(CommonFormModel employee) async {
    try {
      // Upload photo to Firebase Storage
      String photoURL = '';
      if (employee.photo != null) {
        final String photoFileName =
            'employee_photos/${employee.name}_${DateTime.now().millisecondsSinceEpoch}.png';
        firebase_storage.UploadTask task = firebase_storage
            .FirebaseStorage.instance
            .ref(photoFileName)
            .putData(await employee.photo!.readAsBytes());

        await task.whenComplete(() async {
          photoURL = await task.snapshot.ref.getDownloadURL();
        });
        log(photoFileName);
      }

      DatabaseReference employeeDataReference =
          FirebaseDatabase.instance.ref().child('EmployeeData');

      // Push data to the 'EmployeeData' node, which will generate a unique key
      DatabaseReference newEmployeeReference = employeeDataReference.push();

      // Create a new child node (subcollection) under the 'Monthly' node with the current month as the child name
      String currentMonth = DateFormat('MMMM').format(DateTime.now());
      DatabaseReference subcollectionReference =
          newEmployeeReference.child('Monthly').child(currentMonth);

      // Add data to the new subcollection
      await subcollectionReference.set(
        {
          'name': employee.name,
          'photo': photoURL,
          'category': employee.category,
          'reference': employee.reference,
          'rate': employee.rate,
          'attendance': employee.attendance,
          'amount': employee.amount,
          'advance': employee.advance,
          'kharcha': employee.kharcha,
          'autoRent': employee.autoRent,
          'createdAt': ServerValue.timestamp,
        },
      );

      return true;
    } catch (e) {
      print('Error adding employee: $e');
      return false;
    }
  }

  static Future<void> updateEmployee(
      {required String documentId,
      String? advance,
      String? kharcha,
      String? autoRent,
      String? rate,
      String? attendance,
      CommonFormModel? presentEmployee // New field
      }) async {
    try {
      // DateTime nowTime = DateTime.now();

      // final now = DateTime.now().toString();

      // Construct the path to the employee's data
      final DatabaseReference employeeDataReference = FirebaseDatabase.instance
          .ref()
          .child('EmployeeData')
          .child(documentId);

      // Assuming 'Monthly' is another Map inside each employee
      final DatabaseReference monthlyReference =
          employeeDataReference.child('Monthly');

      // Get the current running month

      String currentMonth = DateFormat('MMMM').format(DateTime.now());

      // Construct the path to the employee's data for the current running month
      final DatabaseReference currentMonthReference =
          monthlyReference.child(currentMonth);

      final Map<String, dynamic> updateFields = {};

      if (advance != null) {
        updateFields['advance'] = advance;
        //  updateFields['lastUpdateAdvance'] = now;
      }

      if (kharcha != null) {
        updateFields['kharcha'] = kharcha;
        //   updateFields['lastUpdateKharcha'] = now;
      }

      if (autoRent != null) {
        updateFields['autoRent'] = autoRent;
        //  updateFields['lastUpdateAutoRent'] = now;
      }

      if (rate != null) {
        updateFields['rate'] = rate;
        //  updateFields['lastUpdateRate'] = now;
      }

      if (attendance != null) {
        updateFields['attendance'] = attendance;
        //  updateFields['lastUpdateAttendance'] = now;
      }

      // Check if the current month node already exists
      final DatabaseEvent currentMonthSnapshot =
          await currentMonthReference.once();

      log("current month snapshot ${currentMonthSnapshot.snapshot.exists.toString()}");
      if (currentMonthSnapshot.snapshot.exists) {
        // Update the existing fields under the current month
        await currentMonthReference.update(updateFields);
      } else {
        // Create the current month node if it doesn't exist
        final Map<String, dynamic> updateFields = {};

        updateFields['category'] = presentEmployee!.category;
        updateFields['name'] = presentEmployee.name;
        // updateFields['photo'] = presentEmployee.photo;
        presentEmployee.reference.isNotEmpty
            ? updateFields['reference'] = presentEmployee.reference
            // ignore: unnecessary_statements
            : null;

        if (advance != null) {
          updateFields['advance'] = advance;
          //  updateFields['lastUpdateAdvance'] = now;
        } else {
          updateFields['advance'] = presentEmployee.advance;
        }

        if (kharcha != null) {
          updateFields['kharcha'] = kharcha;
          //   updateFields['lastUpdateKharcha'] = now;
        } else {
          updateFields['kharcha'] = presentEmployee.kharcha;
        }

        if (autoRent != null) {
          updateFields['autoRent'] = autoRent;
          //  updateFields['lastUpdateAutoRent'] = now;
        } else {
          updateFields['autoRent'] = presentEmployee.autoRent;
        }

        if (rate != null) {
          updateFields['rate'] = rate;
          updateFields['amount'] = (int.parse(rate) *
                  int.parse(attendance ?? presentEmployee.attendance))
              .toString();
          //  updateFields['lastUpdateRate'] = now;
        } else {
          updateFields['amount'] = (int.parse(presentEmployee.rate) *
                  int.parse(attendance ?? presentEmployee.attendance))
              .toString();
          updateFields['rate'] = presentEmployee.rate;
        }

        if (attendance != null) {
          updateFields['attendance'] = attendance;
          //  updateFields['lastUpdateAttendance'] = now;
        } else {
          updateFields['attendance'] = presentEmployee.attendance;
        }
        updateFields["createdAt"] = ServerValue.timestamp;

        // updateFields['category'] = presentEmployee.category;
        await currentMonthReference.set(updateFields);
      }
    } catch (e) {
      print('Error updating employee: $e');
    }
  }
}
